local _M = {}

--相对与父节点playerCard
_M[PlayerSit.Bottom] = {

	selfPos = Vector3.New(-537, -360, 0),
	selfAngle = Vector3.New(0, 0, 0),
	selfScale = Vector3.New(2400, 2400, 1200),
	selfSizeDelta = Vector2.New(0.035, 0.047),
	cardStartPos = Vector3.New(0, 0.025, 0),
	selfDistant = 0.034,
	selfAddDis = 0.05,

	handPos = Vector3.New(-0.95, 0.015, -0.13),
	handAngle = Vector3.New(-90, 90, 0),
	handScale = Vector3.New(1.8, 1.8, 1.8),
	handDistant = 0.034,
	handAddDis = 0.05,

	putPos = Vector3.New(-0.53, 0, -0.165),
	putAngle = Vector3.New(0, 90, 0),
	putScale = Vector3.New(1.8, 1.8, 1.8),
	putDistant = 0.0342,
	putHight = -0.047,
	putRowNum = 6,

	chiPos = Vector3.New(-0.92, 0, -0.9),
	chiAngle = Vector3.New(0, 90, 0),
	chiScale = Vector3.New(1.8, 1.8, 1.8),
	chiSplit = -0.12,
	chiUpHight = 0.024,
	chiDistant = 0.0342,
}

_M[PlayerSit.Right] = {
	handPos = Vector3.New(-0.68, 0.015, -1),
	handAngle = Vector3.New(-90, 0, 0),
	handScale = Vector3.New(1.8, 1.8, 1.8),
	handDistant = 0.034,
	handAddDis = 0.05,

	putPos = Vector3.New(-0.413, 0, -0.55),
	putAngle = Vector3.New(0, 0, 0),
	putScale = Vector3.New(1.8, 1.8, 1.8),
	putDistant = 0.0342,
	putHight = -0.047,
	putRowNum = 6,

	chiPos = Vector3.New(0.26, 0, -0.96),
	chiAngle = Vector3.New(0, 0, 0),
	chiScale = Vector3.New(1.8, 1.8, 1.8),
	chiSplit = -0.12,
	chiUpHight = 0.024,
	chiDistant = 0.0342,
}

_M[PlayerSit.Up] = {
	handPos = Vector3.New(0.39, 0.015, -0.77),
	handAngle = Vector3.New(-90, -90, 0),
	handScale = Vector3.New(1.8, 1.8, 1.8),
	handDistant = 0.034,
	handAddDis = 0.05,

	putPos = Vector3.New(-0.01, 0, -0.47),
	putAngle = Vector3.New(0, -90, 0),
	putScale = Vector3.New(1.8, 1.8, 1.8),
	putDistant = 0.0342,
	putHight = -0.047,
	putRowNum = 6,

	chiPos = Vector3.New(0.38, 0, 0.15),
	chiAngle = Vector3.New(0, -90, 0),
	chiScale = Vector3.New(1.8, 1.8, 1.8),
	chiSplit = -0.12,
	chiUpHight = 0.024,
	chiDistant = 0.0342,
}

_M[PlayerSit.Left] = {
	handPos = Vector3.New(0.14, 0.015, 0.35),
	handAngle = Vector3.New(-90, 180, 0),
	handScale = Vector3.New(1.8, 1.8, 1.8),
	handDistant = 0.034,
	handAddDis = 0.05,

	putPos = Vector3.New(-0.12, 0, -0.09),
	putAngle = Vector3.New(0, 180, 0),
	putScale = Vector3.New(1.8, 1.8, 1.8),
	putDistant = 0.0342,
	putHight = -0.047,
	putRowNum = 6,

	chiPos = Vector3.New(-0.71, 0, 0.32),
	chiAngle = Vector3.New(0, 180, 0),
	chiScale = Vector3.New(1.8, 1.8, 1.8),
	chiSplit = -0.12,
	chiUpHight = 0.024,
	chiDistant = 0.0342,
}

_M.tableCards = {
	[PlayerSit.Up] = {
		pos = Vector3.New(0.27, 0, 0.07),
		angle = Vector3.New(180, 90, 0),
		scale = Vector3.New(1.6, 1.6, 1.6),
		distant = 0.054,
		hight = 0.04,
		num = 14,
	},

	[PlayerSit.Right] = {
		pos = Vector3.New(-0.61, 0, 0.2),
		angle = Vector3.New(180, 0, 0),
		scale = Vector3.New(1.6, 1.6, 1.6),
		distant = 0.054,
		hight = 0.04,
		num = 13,
	},

	[PlayerSit.Left] = {
		pos = Vector3.New(0.05, 0, -0.85),
		angle = Vector3.New(180, 0, 0),
		scale = Vector3.New(1.6, 1.6, 1.6),
		distant = 0.054,
		hight = 0.04,
		num = 13,
	},
	
	[PlayerSit.Bottom] = {
		pos = Vector3.New(-0.78, 0, -0.69),
		angle = Vector3.New(180, 90, 0),
		scale = Vector3.New(1.6, 1.6, 1.6),
		distant = 0.054,
		hight = 0.04,
		num = 14,
	},
}

_M.DealCardTime = 0.4		--没次发牌间隔时间
_M.DealPlayAniTime = 0.08	--发牌动画
_M.DealEndWaitTime = 0.8	--发完牌等整理牌的时间
_M.SortCardTime = 0.4		--整理牌扣下等待时间
_M.SortAni1Time = 0.3		--整理牌时牌扣下的动画时间
_M.SortAni2Time = 0.3		--整理牌时牌翻上来的动画时间
_M.CardMoveTime = 0.5		--整理牌时牌移动的时间
_M.CardUpHight = 0.05		--移动牌时上移距离
_M.CardUpAniTime = 0.5			--移动牌时上移时间
_M.CardUpWaitTime = 0.3			--移动牌时上移后等待时间
_M.CardCrossAniTime = 0.3		--移动牌时平移时间
_M.CardCrossWaitTime = 0.3		--移动牌时平移后等待时间
_M.CardDownTime = 0.5		--移动牌时下移时间
_M.ScoreShowTime = 3		--分数显示时间
_M.TableUpTime = 0.8		--桌子上升动画时间
return _M