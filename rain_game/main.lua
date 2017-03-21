function love.load()
	lg = love.graphics
	lk = love.keyboard
	la = love.audio
	lm = love.mouse

-- camera view width/height (NOT whole canvas)
	width = 800 
	height = 450 
	love.window.setMode(width, height)
	math.randomseed(os.clock())
	lg.setDefaultFilter("linear","nearest",1)
	require "commonUtilities"
	Camera = require "hump.camera"
---------------------------------------------------------------------------------

	img_background = lg.newImage("background_placeholder_bigger.png")
	img_player = lg.newImage("testrectimg.png")
	camera = Camera(0,0)



	pw = 100	
	ph = 100

	--FORMULA FOR ROOM CALC:
	--   PX: psd x position + 400, then account for 20px borders
	--   PY: row 1: 375
	--       row 2: 845
	--       row 3: 1315

	--ROOM: forest (default), tree, creek, cave, barn, loft, machine
	--Changes player starting location to appropriate screen
	--Limit determines movement boundaries for player
	room = "cave" 

	if room == "forest" then --start w/default, move L to R thru screens
		py = 845
		limitL = 2490
		limitR = 4790
	elseif room == "machine" then		
		py = 845
		limitL = 50
		limitR = 1150
	elseif room == "barn" then
		py = 845
		limitL = 1270
		limitR = 2370
	elseif room == "loft" then
		py = 375
		limitL = 1270
		limitR = 1970
	elseif room == "tree" then
		py = 375
		limitL = 3290
		limitR = 3990
	elseif room == "creek" then
		py = 1315
		limitL = 4090 
		limitR = 4790
	elseif room == "cave" then
		py = 845
		limitL = 4910 
		limitR = 6010
	end

	--player xpos always starts 400px away from room edge
	px = limitL + 350

end

function love.update()
	
	if lk.isDown("a") and px > limitL then
		px = px - 4.5
	elseif lk.isDown("d") and px < limitR then
		px = px + 4.5
	end

-- lock camera position for small rooms, follow player for others
-- in larger rooms, switch to locked camera at edges
	if room == "loft" or room == "tree" or room == "creek" then
		camera:lockPosition(limitL+350,py-150)
	elseif px < limitL+350 then
		camera:lockPosition(limitL+350,py-150)
	elseif px > limitR-350 then
		camera:lockPosition(limitR-350,py-150)
	else
		camera:lookAt(px,py-150)
	end

end

function love.draw()
	camera:attach()

	--img name, x, y, rotation (radians), width stretch, height stretch, pinx, piny)
	lg.draw(img_background, 0, 0, 0, 1, 1)

	lg.draw(img_player, px, py, 0, 1, 1, pw/2, ph)


	--lg.rectangle("fill", px, py, pw, ph) --good ol' rectangle boy, drawn
	camera:detach()

end