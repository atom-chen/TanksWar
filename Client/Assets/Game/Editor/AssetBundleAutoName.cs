//using UnityEngine;
//using UnityEditor;
//using System.Collections.Generic;
//using System.IO;

//public class AssetBundleAutoName : AssetPostprocessor 
//{
//    private static void OnPostprocessAllAssets(string[] importedAssets, string[] deletedAssets, string[] movedAssets, string[] movedFromAssetPaths)
//    {
//        AutoName(importedAssets);
//        AutoName(movedAssets);
//    }

//    static void AutoName(string[] assetPaths)
//    {
//        foreach (string importedAsset in assetPaths)
//        {
//            // Resources 目录下的不打包
//            if (importedAsset.Contains("Resources"))
//                continue;

//            // Internal 目录下的不打包
//            if (importedAsset.Contains("Internal"))
//                continue;

//            // UGUI prefab 判断
//            if (importedAsset.StartsWith("Assets/UGUI/Prefabs/") && importedAsset.EndsWith(".prefab"))
//            {
//                string prefabName = Path.GetFileNameWithoutExtension(importedAsset);
//                AssetImporter assetImporter = AssetImporter.GetAtPath(importedAsset) as AssetImporter;
//                assetImporter.assetBundleName = "Assets/UGUI/Prefabs/" + prefabName + ".unity3d";
//                continue;
//            }

//            // UGUI 图集 判断
//            if (importedAsset.StartsWith("Assets/UGUI/Atlas/") && IsTexture(importedAsset))
//            {
//                string atlasName = new DirectoryInfo(Path.GetDirectoryName(importedAsset)).Name;
//                string atlasPath = Path.GetDirectoryName(importedAsset);
//                AssetImporter assetImporter = AssetImporter.GetAtPath(atlasPath) as AssetImporter;
//                assetImporter.assetBundleName = "Assets/UGUI/Atlas/" + atlasName + ".unity3d";
//                continue;
//            }

//            // UGUI 字体 判断
//            if (importedAsset.StartsWith("Assets/Game/UI/Fonts/") && (importedAsset.EndsWith(".ttf") || importedAsset.EndsWith(".TTF")))
//            {
//                string fontName = Path.GetFileNameWithoutExtension(importedAsset);
//                AssetImporter assetImporter = AssetImporter.GetAtPath(importedAsset) as AssetImporter;
//                assetImporter.assetBundleName = "Assets/Game/Resources/Fonts/" + fontName + ".unity3d";
//                continue;
//            }

//            // UGUI 动画文件 判断
//            if (importedAsset.StartsWith("Assets/UGUI/Animations/") && importedAsset.EndsWith(".controller"))
//            {
//                AssetImporter assetImporter = AssetImporter.GetAtPath(importedAsset) as AssetImporter;
//                assetImporter.assetBundleName = "Assets/UGUI/animations.unity3d";
//                continue;
//            }

//            // UGUI 音效文件 判断
//            if (importedAsset.StartsWith("Assets/UGUI/Audios/") && IsAudio(importedAsset))
//            {
//                AssetImporter assetImporter = AssetImporter.GetAtPath(importedAsset) as AssetImporter;
//                assetImporter.assetBundleName = "Assets/UGUI/audios.unity3d";
//                continue;
//            }

//            // 背景音乐 判断
//            if (importedAsset.StartsWith("Assets/Audios/BG/") && IsAudio(importedAsset))
//            {
//                if (!CheckAssetPrefixName(importedAsset, "bg_"))
//                    continue;

//                AssetImporter assetImporter = AssetImporter.GetAtPath(importedAsset) as AssetImporter;
//                assetImporter.assetBundleName = "Assets/Audios/BG.unity3d";
//                continue;
//            }

//            // 音效 判断
//            if (importedAsset.StartsWith("Assets/Audios/SE/") && IsAudio(importedAsset))
//            {
//                if (!CheckAssetPrefixName(importedAsset, "se_"))
//                    continue;

//                AssetImporter assetImporter = AssetImporter.GetAtPath(importedAsset) as AssetImporter;
//                assetImporter.assetBundleName = "Assets/Audios/SE.unity3d";
//                continue;
//            }

//            // 3D场景特效 判断
//            if (importedAsset.StartsWith("Assets/Effects/3D/") && importedAsset.EndsWith(".prefab"))
//            {
//                if (!CheckAssetPrefixName(importedAsset, "3d_"))
//                    continue;

//                AssetImporter assetImporter = AssetImporter.GetAtPath(importedAsset) as AssetImporter;
//                assetImporter.assetBundleName = "Assets/Effects/3D.unity3d";
//                continue;
//            }

//            // 2D界面特效 判断
//            if (importedAsset.StartsWith("Assets/Effects/2D/") && importedAsset.EndsWith(".prefab"))
//            {
//                if (!CheckAssetPrefixName(importedAsset, "2d_"))
//                    continue;

//                AssetImporter assetImporter = AssetImporter.GetAtPath(importedAsset) as AssetImporter;
//                assetImporter.assetBundleName = "Assets/Effects/2D.unity3d";
//                continue;
//            }

//            // 场景文件 判断
//            if (importedAsset.StartsWith("Assets/Scenes/") && importedAsset.EndsWith(".unity"))
//            {
//                string sceneName = Path.GetFileNameWithoutExtension(importedAsset);
//                AssetImporter assetImporter = AssetImporter.GetAtPath(importedAsset) as AssetImporter;
//                assetImporter.assetBundleName = "Assets/Scenes/" + sceneName + ".unity3d";
//                continue;
//            }

//            // 场景共享资源 判断(顶层目录划分)
//            if (importedAsset.StartsWith("Assets/Scenes/ShareRes"))
//            {
//                string[] words = importedAsset.Split('/', '\\');
//                string shareFolder = words[0] + '/' + words[1] + '/' + words[2] + '/' + words[3];
//                AssetImporter assetImporter = AssetImporter.GetAtPath(importedAsset) as AssetImporter;
//                assetImporter.assetBundleName = shareFolder + ".unity3d";
//                continue;
//            }

//            // 动态模型文件 判断
//            if (importedAsset.StartsWith("Assets/Models/"))
//            {
//                string modelFolder = Path.GetDirectoryName(importedAsset);
//                string modelName = new DirectoryInfo(modelFolder).Name;
//                if (modelName == "Models")
//                    continue;

//                AssetImporter assetImporter = AssetImporter.GetAtPath(importedAsset) as AssetImporter;
//                assetImporter.assetBundleName = modelFolder + ".unity3d";
//                continue;
//            }

//            // 动画文件 判断
//            if (importedAsset.StartsWith("Assets/Animations/") && importedAsset.EndsWith(".controller"))
//            {
//                AssetImporter assetImporter = AssetImporter.GetAtPath(importedAsset) as AssetImporter;
//                assetImporter.assetBundleName = "Assets/animations.unity3d";
//                continue;
//            }
//        }
//    }

//    // 检测资源名称前缀
//    static bool CheckAssetPrefixName(string assetPath, string prefixName)
//    {
//        string assetName = Path.GetFileNameWithoutExtension(assetPath);
//        if (!assetName.StartsWith(prefixName))
//        {
//            string error = AssetDatabase.RenameAsset(assetPath, prefixName + assetName);
//            if (!string.IsNullOrEmpty(error))
//                Debug.LogWarning(error);
//            return false;
//        }
//        return true;
//    }

//    // 判断是否是贴图
//    static bool IsTexture(string assetPath)
//    {
//        return assetPath.EndsWith(".png") || assetPath.EndsWith(".tga") || assetPath.EndsWith(".psd") || assetPath.EndsWith(".jpg") || assetPath.EndsWith(".bmp");
//    }

//    // 判断是否是音频文件
//    static bool IsAudio(string assetPath)
//    {
//        return assetPath.EndsWith(".wav") || assetPath.EndsWith(".mp3");
//    }

//    // 判断是否是场景依赖文件
//    static bool IsSceneDepend(string assetPath)
//    {
//        return IsTexture(assetPath) || IsAudio(assetPath) || assetPath.EndsWith(".mat") || assetPath.EndsWith(".prefab") || assetPath.EndsWith(".FBX") || assetPath.EndsWith(".controller");
//    }

//}
