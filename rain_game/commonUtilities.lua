--Essential Basics
math.randomseed(os.clock())
love.graphics.setDefaultFilter("nearest")

pi = math.pi

lg = love.graphics
lk = love.keyboard
la = love.audio
lm = love.mouse

--Establish the name space
cu = {}

------------------------------------------------------------------------------
------------------------------------------------------------------------------
--Game Dev
------------------------------------------------------------------------------
------------------------------------------------------------------------------

--Returns when the key is first pressed or clicked
function lk.isClick(key)
	return clickKey == key
end

--To be placed at the beginning of love.keypressed
function cu.registerClick(key)
	clickKey = key
end

--To be placed at the end of love.update
function cu.resetClick()
	clickKey = nil
end

--Plays a sound, and if the sound effect is in the middle of being played it resets it and plays
--Useful for short sound effects
function cu.repplay(sound, base, variation)
	if sound:isStopped() then
		if base and variation then
			sound:setPitch(base+cu.ranFlo(0,variation))
		end
		sound:play()
	else
		sound:rewind()
		sound:play()
	end
end

--Returns current +/- delta, unless it passes or is goal, 
--at which point it returns goal
function cu.approach(goal, current, delta)
	if current > goal then
		local new = current - delta

		if new <= goal then
			return goal
		else
			return new
		end
	elseif current < goal then
		local new = current + delta
		
		if new >= goal then
			return goal
		else
			return new
		end
	else
		return goal
	end
end

--cu.approach for use with angles (delta must be less than pi/2)
function cu.angApproach(goal, current, delta)
	if math.abs(cu.angDis(goal,current-delta)) < math.abs(cu.angDis(goal,current+delta)) then
		if math.abs(cu.angDis(goal,current-delta)) > math.abs(cu.angDis(goal,current)) then
			return goal
		else
			return current - delta
		end
	else
		if math.abs(cu.angDis(goal,current+delta)) > math.abs(cu.angDis(goal,current)) then
			return goal
		else
			return current + delta
		end
	end
end

--Returns 1 for a positive number and -1 for a negative number or 0 for zero
function cu.signOf(n)
	if n > 0 then
		return 1
	elseif n < 0 then
		return -1
	else
		return n
	end
end

--Generates a unique id
function cu.genUID()
	return cu.ranFlo(0,1)
end

------------------------------------------------------------------------------
------------------------------------------------------------------------------
--MATH
------------------------------------------------------------------------------
------------------------------------------------------------------------------


--Lines
------------------------------------------------------------------------------
------------------------------------------------------------------------------

--Returns cu.intercept with slight adjustments to avoid errors with horizontal lines
function cu.intercept(l1p1x,l1p1y, l1p2x,l1p2y, l2p1x,l2p1y, l2p2x,l2p2y, seg1, seg2)
	--Returns the intercept point of two lines or false if they don't
	local function interceptHelper(l1p1x,l1p1y, l1p2x,l1p2y, l2p1x,l2p1y, l2p2x,l2p2y, seg1, seg2)
		local a1,b1,a2,b2 = l1p2y-l1p1y, l1p1x-l1p2x, l2p2y-l2p1y, l2p1x-l2p2x
		local c1,c2 = a1*l1p1x+b1*l1p1y, a2*l2p1x+b2*l2p1y
		local det,x,y = a1*b2 - a2*b1
		if det==0 then return false end
		x,y = (b2*c1-b1*c2)/det, (a1*c2-a2*c1)/det
		if seg1 or seg2 then
			local min,max = math.min, math.max
			if seg1 and not (min(l1p1x,l1p2x) <= x and x <= max(l1p1x,l1p2x) and min(l1p1y,l1p2y) <= y and y <= max(l1p1y,l1p2y)) or
				seg2 and not (min(l2p1x,l2p2x) <= x and x <= max(l2p1x,l2p2x) and min(l2p1y,l2p2y) <= y and y <= max(l2p1y,l2p2y)) then
				return false
			end
		end
		return {x = x, y = y}
	end

	return interceptHelper(l1p1x+.0001,l1p1y+.0001, l1p2x,l1p2y, l2p1x-.0001,l2p1y-.0001, l2p2x,l2p2y, seg1, seg2)
end

--Calls cu.intercept but inputs are points with x and y values.  P(oint)int(ercept).  Pint
function cu.pint(p11,p12,p21,p22)
	return cu.intercept(p11.x,p11.y,p12.x,p12.y,p21.x,p21.y,p22.x,p22.y,true,true)
end

--Distance between two points {x1, y1} {x2, y2}
function cu.dis(x1, y1, x2, y2)
	return math.sqrt((x1-x2)^2 + (y1-y2)^2)
end

--Distance between 0 and {x = x, y = y}
function cu.mag(x, y)
	return math.sqrt((x)^2 + (y)^2)
end

--Distance between two points {x = x1, y = y1} {x = x2, y = y2}
function cu.pDis(p1, p2)
	return math.sqrt((p1.x-p2.x)^2 + (p1.y-p2.y)^2)
end


--Trig
------------------------------------------------------------------------------
------------------------------------------------------------------------------

--Difference between two angles
function cu.angDis(ang1, ang2)
	return math.atan2(math.sin(ang1-ang2), math.cos(ang1-ang2))
end

--Returns point rotated by rot around origin
function cu.pRot(point, rot, origin)
	return {x = math.cos(-rot) * (point.x - 
		origin.x) - 
	math.sin(-rot) * (point.y-origin.y) + origin.x,
	y = math.sin(-rot) * (point.x - origin.x) + math.cos(-rot) * (point.y - origin.y) + origin.y}
end

--Geometry
------------------------------------------------------------------------------
------------------------------------------------------------------------------
function lg.polygon2(type, ...)
	local ps = {}
	for i,v in pairs{...} do
		ps[#ps+1] = v.x
		ps[#ps+1] = v.y
	end
	lg.polygon(type, ps)
end

function lg.rotPolygon(type, rot, origin, verts)
	local ps = {}
	for i,v in ipairs(verts) do
		local rV = cu.pRot(v, rot, origin)
		ps[#ps+1] = rV.x
		ps[#ps+1] = rV.y
	end
	lg.polygon(type, ps)
end

--Tables
------------------------------------------------------------------------------
------------------------------------------------------------------------------

--Maps func onto list
function cu.map(func, list)
	for i,v in ipairs(list) do
		func(v)
	end
end

--Returns the highest value in a contiguously constructed table
function cu.highest(table)
	highest = table[1]
	for i=1, #table do
		if table[i] > highest then
			highest = table[i]
		end
	end
	return highest
end

--Returns the lowest value in a contiguously constructed table
function cu.lowest(table)
	lowest = table[1]
	for i=1, #table do
		if table[i] < lowest then
			lowest = table[i]
		end
	end
	return lowest
end

--Shuffles the items in a table
function cu.shuffle(t)
	local j
	for i = #t, 2, -1 do
		j = math.random(i)
		t[i], t[j] = t[j], t[i]
	end
end

--Copy a table (via Tyler on stackoverflow)
function cu.tableCopy(obj, seen)
	if type(obj) ~= 'table' then return obj end
	if seen and seen[obj] then return seen[obj] end
	local s = seen or {}
	local res = setmetatable({}, getmetatable(obj))
	s[obj] = res
	for k, v in pairs(obj) do res[cu.tableCopy(k, s)] = cu.tableCopy(v, s) end
	return res
end

--Transfer the data from tableA to tableB
function cu.tableTransfer(tableA, tableB)
	for i,v in pairs(tableA) do
		if tableB[i] ~= nil then
			tableB[i] = tableA[i]
		end
	end
end

--Copy a table (via Tyler on stackoverflow)
function cu.tableContains(table, obj)
	for i,v in ipairs(table) do
		if v == obj then
			return true
		end
	end

	return false
end

--Random
------------------------------------------------------------------------------
------------------------------------------------------------------------------

--Generate a float random
function cu.ranFlo(low,up)
	if up == nil then
		return math.random()*(low)
	else
		return low+math.random()*(up-low)
	end
end

--Flips a coin, if heads return 1, if tails return -1
function cu.flip()
	if math.random() > .5 then
		return 1
	else
		return -1
	end
end



------------------------------------------------------------------------------
------------------------------------------------------------------------------
--Color
------------------------------------------------------------------------------
------------------------------------------------------------------------------

--Assumes a table of color and applies a tone and alpha value
function cu.setColor(table, a, tone)
	tone = tone or 1
	a = a or 255
	lg.setColor(table[1]*tone, table[2]*tone, table[3]*tone, a)
end

local r1, r2 =  0          ,  1.0
local g1, g2 = -math.sqrt( 3 )/2, -0.5
local b1, b2 = math.sqrt( 3 )/2, -0.5
--Adapted from kidanger
function cu.HSV2RGB(h, s, v, a)

	s = s/255
	v = v/255
	a = a/255

	h=h+pi/2
	local r, g, b = 1, 1, 1
	local h1, h2 = math.cos( h ), math.sin( h )

	--hue
	r = h1*r1 + h2*r2
	g = h1*g1 + h2*g2
	b = h1*b1 + h2*b2
	--saturation
	r = r + (1-r)*s
	g = g + (1-g)*s
	b = b + (1-b)*s

	r,g,b = r*v, g*v, b*v

	return {r*255, g*255, b*255, (a or 1) * 255}
end

function lg.setHSV(h,s,b,a)
	lg.setColor(cu.HSV2RGB(h, s, b, a))
end

------------------------------------------------------------------------------
------------------------------------------------------------------------------
--MISC
------------------------------------------------------------------------------
------------------------------------------------------------------------------

--Allows array style substring
getmetatable('').__index = function(str,i)
	if type(i) == 'number' then
		return string.sub(str,i,i)
	else
		return string[i]
	end
end