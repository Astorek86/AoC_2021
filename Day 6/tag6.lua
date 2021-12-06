-- Change this to 80 to get the Answer from the first Puzzle
local DAYS_END <const> = 256  -- Using Lua < 5.4 ? Then remove "<const>".

local SQUIDS_MAX <const> = 8  -- Using Lua < 5.4 ? Then remove "<const>".

local SQUIDS = {}  -- Store all Squids here.

function reduce()
	for i=0,SQUIDS_MAX do
		SQUIDS[i-1] = SQUIDS[i]
		SQUIDS[i] = 0
	end
	SQUIDS[6] = SQUIDS[6] + SQUIDS[-1]
	SQUIDS[8] = SQUIDS[8] + SQUIDS[-1]
	SQUIDS[-1] = 0
end

function count()
	local ret = 0
	for i=0,SQUIDS_MAX do
		ret = ret + SQUIDS[i]
	end
	return ret
end

function debugprint()
	for i=-1,SQUIDS_MAX do
		print("SQUIDS["..i.."] = "..SQUIDS[i])
	end
	print("---")
end

function main()
	myarray = "1,1,1,1,3,1,4,1,4,1,1,2,5,2,5,1,1,1,4,3,1,4,1,1,1,1,1,1,1,2,1,2,4,1,1,1,1,1,1,1,3,1,1,5,1,1,2,1,5,1,1,1,1,1,1,1,1,4,3,1,1,1,2,1,1,5,2,1,1,1,1,4,5,1,1,2,4,1,1,1,5,1,1,1,1,5,1,3,1,1,4,2,1,5,1,2,1,1,1,1,1,3,3,1,5,1,1,1,1,3,1,1,1,4,1,1,1,4,1,4,3,1,1,1,4,1,2,1,1,1,2,1,1,1,1,5,1,1,3,5,1,1,5,2,1,1,1,1,1,4,4,1,1,2,1,1,1,4,1,1,1,1,5,3,1,1,1,5,1,1,1,4,1,4,1,1,1,5,1,1,3,2,2,1,1,1,4,1,3,1,1,1,2,1,3,1,1,1,1,4,1,1,1,1,2,1,4,1,1,1,1,1,4,1,1,2,4,2,1,2,3,1,3,1,1,2,1,1,1,3,1,1,3,1,1,4,1,3,1,1,2,1,1,1,4,1,1,3,1,1,5,1,1,3,1,1,1,1,5,1,1,1,1,1,2,3,4,1,1,1,1,1,2,1,1,1,1,1,1,1,3,2,2,1,3,5,1,1,4,4,1,3,4,1,2,4,1,1,3,1"
	--myarray = "3,4,3,1,2"
	
	-- Count Squids and fill the SQUID-Array:
	for i=-1,SQUIDS_MAX do
		_, SQUIDS[i] = string.gsub(myarray, i, i)
	end
	
	days = 0
	while true do
		days = days + 1
		reduce()
		if days==DAYS_END then
			break
		end
	end
	debugprint()
	
	-- That's the Answer...
	print(count())
end

main()
