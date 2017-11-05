local _M = {}

--相对与父节点playerCard
_M[PlayerSit.Bottom] = {

	handPos = Vector3.New(-520, -360, 0),
	handAngle = Vector3.New(0, 0, 0),
	handScale = Vector3.New(2400, 2400, 1200),
	handSizeDelta = Vector2.New(0.035, 0.047),
	cardStartPos = Vector3.New(0, 0.025, 0),
	handDistant = 0.034,

	putPos = Vector3.New(-0.53, 0, -0.165),
	putAngle = Vector3.New(0, 90, 0),
	putScale = Vector3.New(1.8, 1.8, 1.8),
	putDistant = 0.0342,
	putHight = -0.047,
	putRowNum = 6,

	chiPos = Vector3.New(-0.92, 0, -0.9),
	chiAngle = Vector3.New(0, 90, 0),
	chiScale = Vector3.New(1.8, 1.8, 1.8),
	chiSplit = -0.06,
	chiUpHight = 0.024,
	chiDistant = 0.0342,
}

_M[PlayerSit.Right] = {
	handPos = Vector3.New(-0.68, 0.015, -1),
	handAngle = Vector3.New(-90, 0, 0),
	handScale = Vector3.New(1.8, 1.8, 1.8),
	handDistant = 0.034,

	putPos = Vector3.New(-0.413, 0, -0.55),
	putAngle = Vector3.New(0, 0, 0),
	putScale = Vector3.New(1.8, 1.8, 1.8),
	putDistant = 0.0342,
	putHight = -0.047,
	putRowNum = 6,

	chiPos = Vector3.New(0.26, 0, -0.96),
	chiAngle = Vector3.New(0, 0, 0),
	chiScale = Vector3.New(1.8, 1.8, 1.8),
	chiSplit = -0.06,
	chiUpHight = 0.024,
	chiDistant = 0.0342,
}

_M[PlayerSit.Up] = {
	handPos = Vector3.New(0.39, 0.015, -0.77),
	handAngle = Vector3.New(-90, -90, 0),
	handScale = Vector3.New(1.8, 1.8, 1.8),
	handDistant = 0.034,

	putPos = Vector3.New(-0.01, 0, -0.47),
	putAngle = Vector3.New(0, -90, 0),
	putScale = Vector3.New(1.8, 1.8, 1.8),
	putDistant = 0.0342,
	putHight = -0.047,
	putRowNum = 6,

	chiPos = Vector3.New(0.38, 0, 0.15),
	chiAngle = Vector3.New(0, -90, 0),
	chiScale = Vector3.New(1.8, 1.8, 1.8),
	chiSplit = -0.06,
	chiUpHight = 0.024,
	chiDistant = 0.0342,
}

_M[PlayerSit.Left] = {
	handPos = Vector3.New(0.14, 0.015, 0.35),
	handAngle = Vector3.New(-90, 180, 0),
	handScale = Vector3.New(1.8, 1.8, 1.8),
	handDistant = 0.034,

	putPos = Vector3.New(-0.12, 0, -0.09),
	putAngle = Vector3.New(0, 180, 0),
	putScale = Vector3.New(1.8, 1.8, 1.8),
	putDistant = 0.0342,
	putHight = -0.047,
	putRowNum = 6,

	chiPos = Vector3.New(-0.71, 0, 0.32),
	chiAngle = Vector3.New(0, 180, 0),
	chiScale = Vector3.New(1.8, 1.8, 1.8),
	chiSplit = -0.06,
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

_M.DealCardTime = 0.8

return _M