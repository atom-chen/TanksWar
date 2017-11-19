using UnityEditor;
using UnityEngine;
using System.IO;
using System.Text;
using System.Collections;
using System;
using System.Collections.Generic;
//using System.Diagnostics;
using UnityEditor.SceneManagement;
using UnityEngine.SceneManagement;
using UnityEditor.Callbacks;

public class Packager {
    public static string platform = string.Empty;
    static List<string> paths = new List<string>();
    static List<string> m_files = new List<string>();
    static List<AssetBundleBuild> maps = new List<AssetBundleBuild>();

    static string KeystoreName = "user.keystore";
    static string KeyaliasName = "ahpg";
    static string KeystorePassword = "6FK)e]KCRkmnw(VJY9";
    static string KeyaliasPassword = "6FK)e]KCRkmnw(VJY9";
    static int version = 100;
    ///-----------------------------------------------------------
    static string[] exts = { ".txt", ".xml", ".lua", ".assetbundle", ".json" };
    static bool CanCopy(string ext) {   //能不能复制
        foreach (string e in exts) {
            if (ext.Equals(e)) return true;
        }
        return false;
    }

    /// <summary>
    /// 载入素材
    /// </summary>
    static UnityEngine.Object LoadAsset(string file) {
        if (file.EndsWith(".lua")) file += ".txt";
        return AssetDatabase.LoadMainAssetAtPath("Assets/Game/Examples/Builds/" + file);
    }

#if UNITY_IPHONE || UNITY_IOS
    [MenuItem("Game/Build Resource", false, 100)]
    public static void BuildiPhoneResource() {
        BuildTarget target;
#if UNITY_5
        target = BuildTarget.iOS;
#else
        target = BuildTarget.iPhone;
#endif
        BuildAssetResource(target);
    }
#endif

#if UNITY_ANDROID
    [MenuItem("Game/Build Resource", false, 101)]
    public static void BuildAndroidResource() {
        BuildAssetResource(BuildTarget.Android);
    }
#endif

    //[MenuItem("Game/Build Windows Resource", false, 102)]
    //public static void BuildWindowsResource() {
    //    BuildAssetResource(BuildTarget.StandaloneWindows);
    //}

    /// <summary>
    /// 生成绑定素材
    /// </summary>
    public static void BuildAssetResource(BuildTarget target) {
        if (Directory.Exists(Util.DataPath))
        {
            Directory.Delete(Util.DataPath, true);
        }
        string streamPath = Application.streamingAssetsPath;
        if (Directory.Exists(streamPath))
        {
            Directory.Delete(streamPath, true);
        }
        Directory.CreateDirectory(streamPath);
        AssetDatabase.Refresh();

        maps.Clear();
        if (AppConst.LuaBundleMode)
        {
            HandleLuaBundle();
        }
        else
        {
            HandleLuaFile();
        }

        //HandleGameBundle();
        string path = AppDataPath + "/" + AppConst.AssetDir + "/";
        if (!Directory.Exists(path)) Directory.CreateDirectory(path);

        string resPath = "Assets/" + AppConst.AssetDir;
        //主要处理lua文件
        if (maps.Count > 0)
            BuildPipeline.BuildAssetBundles(resPath, maps.ToArray(), BuildAssetBundleOptions.None, target);

        //打包已有bundlename的资源
        BuildPipeline.BuildAssetBundles(resPath, BuildAssetBundleOptions.None, target);

        SetPlayerSetting();
        BuildScene(target);

        BuildFile();
    }

    static void BuildScene(BuildTarget target)
    {
        string testResPath = "Assets/" + AppConst.AppName + "/Scene/";
        m_files.Clear();
        Recursive(testResPath);
        Dictionary<string, List<string>> sceneDict = new Dictionary<string, List<string>>();
        foreach (string f in m_files)
        {
            if (!f.EndsWith(".unity"))
                continue;

            string fileName = Path.GetFileName(f);
            string filePath = f.Replace('\\', '/');
            string[] fList = filePath.Split('/');
            string modName = fList[fList.Length-2].ToLower()+"_scene";
            if (sceneDict.ContainsKey(modName))
            {
                sceneDict[modName].Add(fileName);
            }
            else
            {
                List<string> files = new List<string>();
                files.Add(filePath);
                sceneDict.Add(modName, files);
            }

        }

        Caching.CleanCache();
        foreach (var v in sceneDict)
        {
            string assetPath = Application.dataPath + "/" + AppConst.AssetDir + "/"+ v.Key+ AppConst.ExtName;
            BuildPipeline.BuildPlayer(v.Value.ToArray(), assetPath, target, BuildOptions.BuildAdditionalStreamedScenes);
        }
        AssetDatabase.Refresh();
    }


    [MenuItem("Game/Update Lua No Build", false, 33)]
    public static void UpdateResourceNoBuild()
    {
        //先复制lua文件到StreamingAssets文件夹

        string streamingPath = "Assets/" + AppConst.AssetDir + "/lua/";
        string testResPath = "Assets/" + AppConst.AppName + "/Lua/";
        m_files.Clear();
        Recursive(testResPath);
        foreach (string f in m_files)
        {
            if (f.EndsWith(".meta") || f.Contains(".DS_Store") || f.Contains(".git") || f.Contains(".gitignore")) continue;

            string fileName = Path.GetFileName(f);

            string relativePath = f.Replace(testResPath, string.Empty);
            string relativeFolder = relativePath.Replace(fileName, string.Empty);

            string tpath = streamingPath + relativeFolder;
            if (!Directory.Exists(tpath)) Directory.CreateDirectory(tpath);
            string destfile = tpath + fileName;
            File.Copy(f, destfile, true);
        }
        AssetDatabase.Refresh();

        BuildFile();
    }

    static void BuildFile()
    {
        BuildFileIndex();

        string streamDir = Application.dataPath + "/" + AppConst.LuaTempDir;
        if (Directory.Exists(streamDir)) Directory.Delete(streamDir, true);
        AssetDatabase.Refresh();

        if (AppConst.UpdateResource)
        {
            string testResPath = "Assets/" + AppConst.AssetDir + "/";
            string testPath = Application.dataPath + "/" + AppConst.TestResourceFolder;
            if (!Directory.Exists(testPath))
            {
                Directory.CreateDirectory(testPath);
            }

            m_files.Clear();
            Recursive(testResPath);
            foreach (string f in m_files)
            {
                if (f.EndsWith(".meta") || f.Contains(".DS_Store") || f.Contains(".git") || f.Contains(".gitignore")) continue;

                string fileName = Path.GetFileName(f);

                string relativePath = f.Replace(testResPath, string.Empty);
                string relativeFolder = relativePath.Replace(fileName, string.Empty);

                string tpath = testPath + relativeFolder;
                if (!Directory.Exists(tpath)) Directory.CreateDirectory(tpath);
                string destfile = tpath + fileName;
                File.Copy(f, destfile, true);
            }
            AssetDatabase.Refresh();
        }
    }

    static void AddBuildMap(string bundleName, string pattern, string path, bool bAddAssetBundle = false) {
        string[] patterns = pattern.Split('|');
        List<string[]> filesList = new List<string[]>();
        int fileCount = 0;
        foreach (string pat in patterns)
        {
            string[] tempFiles = Directory.GetFiles(path, pat);
            fileCount += tempFiles.Length;
            filesList.Add(tempFiles);
        }
        string[] files = new string[fileCount];
        int idx = 0;
        for (int i = 0; i < filesList.Count; i++)
        {
            string[] tempFiles = filesList[i];
            tempFiles.CopyTo(files, idx);
            idx += tempFiles.Length;
        }

        if (files.Length == 0) return;

        for (int i = 0; i < files.Length; i++) {
            files[i] = files[i].Replace('\\', '/');
        }

        if (bAddAssetBundle)
        {
            AssetBundleBuild build = new AssetBundleBuild();
            build.assetBundleName = bundleName;
            build.assetNames = files;
            maps.Add(build);
        }
    }

    /// <summary>
    /// 处理Lua代码包
    /// </summary>
    static void HandleLuaBundle() {
        string streamDir = Application.dataPath + "/" + AppConst.LuaTempDir;
        if (!Directory.Exists(streamDir)) Directory.CreateDirectory(streamDir);

        string[] srcDirs = { CustomSettings.luaDir, CustomSettings.FrameworkPath + "/ToLua/Lua" };
        for (int i = 0; i < srcDirs.Length; i++) {
#if UNITY_IPHONE
            ToLuaMenu.CopyLuaBytesFiles(srcDirs[i], streamDir);
#else
            if (AppConst.LuaByteMode)
            {
                string sourceDir = srcDirs[i];
                string[] files = Directory.GetFiles(sourceDir, "*.lua", SearchOption.AllDirectories);
                int len = sourceDir.Length;

                if (sourceDir[len - 1] == '/' || sourceDir[len - 1] == '\\')
                {
                    --len;
                }
                for (int j = 0; j < files.Length; j++)
                {
                    string str = files[j].Remove(0, len);
                    string dest = streamDir + str + ".bytes";
                    string dir = Path.GetDirectoryName(dest);
                    Directory.CreateDirectory(dir);
                    EncodeLuaFile(files[j], dest);
                }
            }
            else
            {
                ToLuaMenu.CopyLuaBytesFiles(srcDirs[i], streamDir);
            }
#endif
        }
        string[] dirs = Directory.GetDirectories(streamDir, "*", SearchOption.AllDirectories);
        for (int i = 0; i < dirs.Length; i++) {
            string name = dirs[i].Replace(streamDir, string.Empty);
            name = name.Replace('\\', '_').Replace('/', '_');
            name = "lua/lua_" + name.ToLower() + AppConst.ExtName;

            string path = "Assets" + dirs[i].Replace(Application.dataPath, "");
            AddBuildMap(name, "*.bytes", path, true);
        }
        AddBuildMap("lua/lua" + AppConst.ExtName, "*.bytes", "Assets/" + AppConst.LuaTempDir, true);

        //-------------------------------处理非Lua文件----------------------------------
        string luaPath = AppDataPath + "/StreamingAssets/lua/";
        for (int i = 0; i < srcDirs.Length; i++) {
            paths.Clear(); m_files.Clear();
            string luaDataPath = srcDirs[i].ToLower();
            Recursive(luaDataPath);
            foreach (string f in m_files) {
                if (f.EndsWith(".meta") || f.EndsWith(".lua")) continue;
                string newfile = f.Replace(luaDataPath, "");
                string path = Path.GetDirectoryName(luaPath + newfile);
                if (!Directory.Exists(path)) Directory.CreateDirectory(path);

                string destfile = path + "/" + Path.GetFileName(f);
                File.Copy(f, destfile, true);
            }
        }
        AssetDatabase.Refresh();
    }
    
    /// <summary>
    /// 处理Lua文件
    /// </summary>
    static void HandleLuaFile() {
        string resPath = AppDataPath + "/StreamingAssets/";
        string luaPath = resPath + "/lua/";

        //----------复制Lua文件----------------
        if (!Directory.Exists(luaPath)) {
            Directory.CreateDirectory(luaPath); 
        }
        string[] luaPaths = { AppDataPath + "/Game/Lua/", 
                              AppDataPath + "/Game/Tolua/Lua/" };

        for (int i = 0; i < luaPaths.Length; i++) {
            paths.Clear(); m_files.Clear();
            string luaDataPath = luaPaths[i].ToLower();
            Recursive(luaDataPath);
            int n = 0;
            foreach (string f in m_files) {
                if (f.EndsWith(".meta")) continue;
                string newfile = f.Replace(luaDataPath, "");
                string newpath = luaPath + newfile;
                string path = Path.GetDirectoryName(newpath);
                if (!Directory.Exists(path)) Directory.CreateDirectory(path);

                if (File.Exists(newpath)) {
                    File.Delete(newpath);
                }
                if (AppConst.LuaByteMode) {
                    EncodeLuaFile(f, newpath);
                } else {
                    File.Copy(f, newpath, true);
                }
                //Util.Log(newpath);
                UpdateProgress(n++, m_files.Count, newpath);
            } 
        }
        EditorUtility.ClearProgressBar();
        AssetDatabase.Refresh();
    }

    static void BuildFileIndex() {
        string resPath = AppDataPath + "/StreamingAssets/";
        ///----------------------创建文件列表-----------------------
        string newFilePath = resPath + "/files.txt";
        if (File.Exists(newFilePath)) File.Delete(newFilePath);

        paths.Clear(); m_files.Clear();
        Recursive(resPath);

        FileStream fs = new FileStream(newFilePath, FileMode.CreateNew);
        StreamWriter sw = new StreamWriter(fs);
        for (int i = 0; i < m_files.Count; i++) {
            string file = m_files[i];
            string ext = Path.GetExtension(file);
            if (file.EndsWith(".meta") || file.Contains(".DS_Store") || file.Contains(".git") || file.Contains(".gitignore")) continue;

            string md5 = Util.md5file(file);
            string value = file.Replace(resPath, string.Empty);
            sw.WriteLine(value + "|" + md5);
        }
        sw.Close(); fs.Close();
    }

    /// <summary>
    /// 数据目录
    /// </summary>
    static string AppDataPath {
        get { return Application.dataPath.ToLower(); }
    }

    /// <summary>
    /// 遍历目录及其子目录
    /// </summary>
    static void Recursive(string path) {
        string[] names = Directory.GetFiles(path);
        string[] dirs = Directory.GetDirectories(path);
        foreach (string filename in names) {
            string ext = Path.GetExtension(filename);
            if (ext.Equals(".meta")) continue;
            m_files.Add(filename.Replace('\\', '/'));
        }
        foreach (string dir in dirs) {
            paths.Add(dir.Replace('\\', '/'));
            Recursive(dir);
        }
    }

    static void UpdateProgress(int progress, int progressMax, string desc) {
        string title = "Processing...[" + progress + " - " + progressMax + "]";
        float value = (float)progress / (float)progressMax;
        EditorUtility.DisplayProgressBar(title, desc, value);
    }

    public static void EncodeLuaFile(string srcFile, string outFile) {
        if (!srcFile.ToLower().EndsWith(".lua")) {
            File.Copy(srcFile, outFile, true);
            return;
        }
        bool isWin = true;
        string luaexe = string.Empty;
        string args = string.Empty;
        string exedir = string.Empty;
        string currDir = Directory.GetCurrentDirectory();
        if (Application.platform == RuntimePlatform.WindowsEditor) {
            isWin = true;
            luaexe = "luajit.exe";
            args = "-b " + srcFile + " " + outFile;
            exedir = AppDataPath.Replace("assets", "") + "LuaEncoder/luajit/";
        } else if (Application.platform == RuntimePlatform.OSXEditor) {
            isWin = false;
            luaexe = "./luac";
            args = "-o " + outFile + " " + srcFile;
            exedir = AppDataPath.Replace("assets", "") + "LuaEncoder/luavm/";
        }
        Directory.SetCurrentDirectory(exedir);
        System.Diagnostics.ProcessStartInfo info = new System.Diagnostics.ProcessStartInfo();
        info.FileName = luaexe;
        info.Arguments = args;
        info.WindowStyle = System.Diagnostics.ProcessWindowStyle.Hidden;
        info.ErrorDialog = true;
        info.UseShellExecute = isWin;
        Util.Log(info.FileName + " " + info.Arguments);

        System.Diagnostics.Process pro = System.Diagnostics.Process.Start(info);
        pro.WaitForExit();
        Directory.SetCurrentDirectory(currDir);
    }
    
    [MenuItem("Game/Open Game Scene", false, 21)]
    public static void OpenGameScene()
    {
        Scene scene = EditorSceneManager.GetActiveScene();
        if (scene.isDirty)
            UnityEngine.Debug.LogError("当前场景未保存");

        if (scene.name == "main")
            return;
        EditorSceneManager.OpenScene("Assets/Game/main.unity");
    }

    [MenuItem("Game/Open UIEditor Scene", false, 22)]
    public static void OpenUIEditorScene()
    {
        Scene scene = EditorSceneManager.GetActiveScene();
        if (scene.isDirty)
            UnityEngine.Debug.LogError("当前场景未保存");

        if (scene.name == "ui_editor")
            return;
        EditorSceneManager.OpenScene("Assets/Game/ui_editor.unity");
    }

    [MenuItem("Game/Open Module Scene/阜阳麻将", false, 23)]
    public static void OpenFYMJ()
    {
        Scene scene = EditorSceneManager.GetActiveScene();
        if (scene.isDirty)
            UnityEngine.Debug.LogError("当前场景未保存");

        if (scene.name == "FYMJ")
            return;
        EditorSceneManager.OpenScene("Assets/Game/Scene/FYMJ/FYMJ.unity");
    }


    [MenuItem("Game/Open Module Scene/涡阳麻将", false, 24)]
    public static void OpenGYMJ()
    {
        Scene scene = EditorSceneManager.GetActiveScene();
        if (scene.isDirty)
            UnityEngine.Debug.LogError("当前场景未保存");

        if (scene.name == "GYMJ")
            return;
        EditorSceneManager.OpenScene("Assets/Game/Scene/GYMJ/GYMJ.unity");
    }

    [MenuItem("Game/Build/打包", false, 32)]
    public static void OnBuild()
    {
        string path = Build(null);
        if (!string.IsNullOrEmpty(path))
            Application.OpenURL(path);
    }

    [MenuItem("Game/Build/打无资源包", false, 33)]
    public static void OnBuildNoResource()
    {
        string resPath = AppDataPath + "/StreamingAssets/";
        ///----------------------创建文件列表-----------------------
        string newFilePath = resPath + "/files.txt";
        if (!File.Exists(newFilePath))
        {
            Debug.LogError("要先build资源");
            return;
        }

        paths.Clear(); m_files.Clear();
        Recursive(resPath);

        for (int i = 0; i < m_files.Count; i++)
        {
            string file = m_files[i];
            if (file.EndsWith("files.txt") || file.EndsWith(".meta") || file.Contains(".DS_Store") || file.Contains(".git") || file.Contains(".gitignore")) continue;
            FileStream fs = new FileStream(file, FileMode.Truncate);
            StreamWriter sw = new StreamWriter(fs);
            sw.WriteLine("");
            sw.Close(); fs.Close();
        }
        AssetDatabase.Refresh();

        string path = Build(null);
        if (!string.IsNullOrEmpty(path))
            Application.OpenURL(path);
    }

    static string Build(string locationPathName)
    {
        try
        {
            AssetDatabase.Refresh();

            List<string> scenes = GetScenes();

            //如果没有指定路径或者路径指定在了asset下，那么放在和asset同级
            string defaultPath = Application.dataPath.Substring(0, Application.dataPath.Length - 7);
            if (string.IsNullOrEmpty(locationPathName) || locationPathName.IndexOf(defaultPath) != -1)
                locationPathName = defaultPath + "/bin";
            locationPathName = locationPathName.Replace("\\", "/");

            //如果是文件，那么拿文件名当文件夹名
            if (!string.IsNullOrEmpty(Path.GetExtension(locationPathName)))
            {
                locationPathName = locationPathName.Substring(0, locationPathName.Length - Path.GetExtension(locationPathName).Length);
            }

            //删掉老的文件夹，创建一个新的
            //if (Directory.Exists(locationPathName))
            //    Directory.Delete(locationPathName, true);
            //Directory.CreateDirectory(locationPathName);

            if (!Directory.Exists(locationPathName))
                Directory.CreateDirectory(locationPathName);

#if UNITY_ANDROID
            string fileName = locationPathName + "/Card_" + System.DateTime.Now.ToString("yyyyMMdd-HHmm") + ".apk";
            BuildTarget buildTarget = BuildTarget.Android;
            SetPlayerSetting();
#endif

#if UNITY_IPHONE
             string fileName = locationPathName;//ios上选择的是路径
             BuildTarget buildTarget = BuildTarget.iOS;
#endif

#if UNITY_STANDALONE_WIN
            string fileName = locationPathName + "/Card.exe";
            BuildTarget buildTarget = BuildTarget.StandaloneWindows;
#endif

            if (!SetTempFolder(true))
            {
                return null;
            }

            string errorMsg = BuildPipeline.BuildPlayer(scenes.ToArray(), fileName, buildTarget, BuildOptions.None);
            if (!string.IsNullOrEmpty(errorMsg))//|| !System.IO.File.Exists(fileName)
            {
                Debug.LogError("errorMsg:" + errorMsg);
            }
            SetTempFolder(false);
            return locationPathName;
        }
        catch (Exception ex)
        {
            Debug.LogException(ex);
            SetTempFolder(false);
        }

        return null;
    }

    [MenuItem("Game/Build/设置需要加载的场景")]
    public static void SetBuildSettingsScene()
    {
        List<EditorBuildSettingsScene> ebss = new List<EditorBuildSettingsScene>();

        foreach (var s in GetScenes())
        {
            ebss.Add(new EditorBuildSettingsScene(s, true));
        }

        EditorBuildSettings.scenes = ebss.ToArray();
    }

    //打包时用不到x86和x86_64目录 需要临时移开
    static bool SetTempFolder(bool bRemove)
    {
        string locationPathName = Application.dataPath.Substring(0, Application.dataPath.Length - 7);
        locationPathName = locationPathName.Replace("\\", "/");
        //string tempx86 = "/x86";
        string tempx86_64 = "/x86_64";
        //string x86Folder = Application.dataPath + "/Plugins" + tempx86;
        string x86_64Folder = Application.dataPath + "/Plugins" + tempx86_64;


        if (bRemove)
        {
            if (!Directory.Exists(x86_64Folder))
            {
                Debug.LogError("Plugins下没找到x86或x86_64目录");
                return false;
            }
            //Directory.Move(x86Folder, locationPathName + tempx86);
            Directory.Move(x86_64Folder, locationPathName + tempx86_64);

            string[] dirs = Directory.GetDirectories("Assets/Game/Resources/");
            locationPathName = locationPathName + "/Resources/";
            if (!Directory.Exists(locationPathName))
                Directory.CreateDirectory(locationPathName);
            foreach (string dir in dirs)
            {
                string path = dir.Replace('\\', '/');
                if (path.EndsWith("Inside") || path.EndsWith("Fonts"))
                    continue;
                int begin = path.LastIndexOf("/");
                string folderName = path.Substring(begin + 1, path.Length - begin - 1);
                string targetPath = locationPathName + folderName;
                Directory.Move(path, targetPath);
            }
        }
        else
        {
            //Directory.Move(locationPathName + tempx86, Application.dataPath + "/Plugins" + tempx86);
            Directory.Move(locationPathName + tempx86_64, Application.dataPath + "/Plugins" + tempx86_64);

            string resPath = locationPathName + "/Resources/";
            string[] dirs = Directory.GetDirectories(resPath);
            foreach (string dir in dirs)
            {
                string path = dir.Replace('\\', '/');
                int begin = path.LastIndexOf("/");
                string folderName = path.Substring(begin + 1, path.Length - begin - 1);
                string targetPath = "Assets/Game/Resources/" + folderName;
                Directory.Move(path, targetPath);
            }
            Directory.Delete(resPath);
        }
        AssetDatabase.Refresh();
        return true;
    }

    public static List<string> GetScenes()
    {
        List<string> l = new List<string>();
        l.Add("Assets/Game/main.unity");
        
        return l;
    }

    public static void SetPlayerSetting()
    {
        PlayerSettings.Android.bundleVersionCode = version;
        // 设置包签名密码
        PlayerSettings.Android.keystoreName = System.Environment.CurrentDirectory.Replace('\\', '/') + "/" + KeystoreName;
        PlayerSettings.Android.keystorePass = KeystorePassword;
        PlayerSettings.Android.keyaliasName = KeyaliasName;
        PlayerSettings.Android.keyaliasPass = KeyaliasPassword;

        // 设置目标设备构架
        PlayerSettings.Android.targetDevice = AndroidTargetDevice.ARMv7;
    }
}