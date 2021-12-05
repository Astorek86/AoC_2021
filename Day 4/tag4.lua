function load_file()
	local ret_firstline = {}
	local ret_boards = {}

	local lines = {}
	for line in io.lines("daten_tag4.txt") do
		lines[#lines+1] = line
	end
	io.close()
	
	-- First line, all Moves
	local start=1
	local firstline = lines[1]
	local c
	for i=1,#firstline do
		c = string.sub(firstline, i, i)
		if c == "," then
			table.insert(ret_firstline, tonumber(string.sub(firstline, start, i-1)))
			start = i+1
		end
	end
	
	-- Second Line, all Boards
	local i
	local y
	local board = {}
	for i,line in ipairs(lines) do
		if i==1 then
			-- First Line, ignore
		elseif #line<10 then
			-- Line too short
			y=0
		else
			y=y+1
			for x=1,5 do
				table.insert(board, {y=y, x=x, marked=false, value=tonumber(string.sub(line, (x-1)*3, (x-1)*3+2))})
			end
		end
	end
	
	-- Seperate Boards
	local current_board = {}
	for i=1,#board do
		-- Also, save if the Board wins...
		board[i].winner = false
		table.insert(current_board, board[i])
		if i%25==0 then
			table.insert(ret_boards, current_board)
			current_board = {}
		end
	end
	
	--[[
	Nochmal die Datenstruktur:
	Board-Liste = Array der Boards (s. nächste Zeile); zusätzlich hat das komplette Board ein "winner"-Key/-Value.
	Array der Boards hat dann Key-Values aus "x", "y", "value" und "marked".
	
	Japp, Lua und seine Tables...
	--]]
	
	return ret_firstline, ret_boards
end


function _marked(lst)
	local ret = true
	for _,v in pairs(lst) do
		if not v.marked then
			ret = false
		end
	end
	return ret
end

function is_winner(_board)
	local ret=false
	local l
	for _,i in ipairs({{1,2,3,4,5},{6,7,8,9,10},{11,12,13,14,15},{16,17,18,19,20},{21,22,23,24,25},{1,6,11,16,21},{2,7,12,17,22},{3,8,13,18,23},{4,9,14,19,24},{5,10,15,20,25}}) do
		l = {}
		for _,j in ipairs(i) do
			table.insert(l, _board[j])
		end
		if _marked(l) then
			ret = true
			break
		end
	end
	return ret
end

function main()
	score = 0
	moves, boards = load_file()
	
	for _,number in ipairs(moves) do
		-- Step 1: Mark Boards
		if DEBUG then print("Nummer "..number.." gezogen.") end
		for iboard,board in ipairs(boards) do
			for icurrent_board,current_board in ipairs(board) do
				-- Step 2: Number in Board found? Mark it!
				if current_board.value == number then
					if DEBUG then print("Board "..iboard.." hat die Nummer bei "..current_board.x.."X, "..current_board.y.."Y.") end
					current_board.marked = true
				end
			end
		end
		-- Step 3: Check Boardwinner(s)
		for iboard,board in ipairs(boards) do
			if not board.winner and is_winner(board) then
				if DEBUG then print("BOARD "..iboard.." GEWINNT!") end
				board.winner = true
				for icurrent_board,current_board in ipairs(board) do
					if not current_board.marked then
						if DEBUG then print("Addiere "..current_board.value.." zu "..score) end
						score = score + current_board.value
					end
				end
				if DEBUG then print("Multipliziere "..score.." mit "..number) end
				score = score * number
				-- First Line = Points for first Puzzle.
				-- Last Line = Points for second Puzzle.
				print("GESAMTPUNKTZAHL: "..score)
				score = 0
				--do return end
			end
		end
	end
end
 
DEBUG=false
main()
