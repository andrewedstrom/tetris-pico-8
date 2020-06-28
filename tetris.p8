pico-8 cartridge // http://www.pico-8.com
version 27
__lua__
local current_piece
local frame
local gravity
local blk_size
local bottom
local right_edge
local blocks
local game_over
local game_over_sound_playing
local tetrinos = {
 { -- i type
  {
   {1, 1, 1, 1},
   {0, 0, 0, 0},
   {0, 0, 0, 0},
   {0, 0, 0, 0}
  },
  {
   {1, 0, 0, 0},
   {1, 0, 0, 0},
   {1, 0, 0, 0},
   {1, 0, 0, 0}
  },
  {
   {1, 1, 1, 1},
   {0, 0, 0, 0},
   {0, 0, 0, 0},
   {0, 0, 0, 0}
  },
  {
   {1, 0, 0, 0},
   {1, 0, 0, 0},
   {1, 0, 0, 0},
   {1, 0, 0, 0}
  }
 },
 { -- o type
  {
   {0, 1, 1, 0},
   {0, 1, 1, 0},
   {0, 0, 0, 0},
   {0, 0, 0, 0}
  },
  {
   {0, 1, 1, 0},
   {0, 1, 1, 0},
   {0, 0, 0, 0},
   {0, 0, 0, 0}
  },
  {
   {0, 1, 1, 0},
   {0, 1, 1, 0},
   {0, 0, 0, 0},
   {0, 0, 0, 0}
  },
  {
   {0, 1, 1, 0},
   {0, 1, 1, 0},
   {0, 0, 0, 0},
   {0, 0, 0, 0}
  }
 },
 { -- j type
  {
   {0, 0, 1, 0},
   {0, 0, 1, 0},
   {0, 1, 1, 0},
   {0, 0, 0, 0}
  },
  {
   {0, 1, 0, 0},
   {0, 1, 1, 1},
   {0, 0, 0, 0},
   {0, 0, 0, 0}
  },
  {
   {0, 1, 1, 0},
   {0, 1, 0, 0},
   {0, 1, 0, 0},
   {0, 0, 0, 0}
  },
  {
   {0, 1, 1, 1},
   {0, 0, 0, 1},
   {0, 0, 0, 0},
   {0, 0, 0, 0}
  }
 },
 { -- l type
  {
   {0, 1, 0, 0},
   {0, 1, 0, 0},
   {0, 1, 1, 0},
   {0, 0, 0, 0}
  },
  {
   {0, 1, 1, 1},
   {0, 1, 0, 0},
   {0, 0, 0, 0},
   {0, 0, 0, 0}
  },
  {
   {0, 1, 1, 0},
   {0, 0, 1, 0},
   {0, 0, 1, 0},
   {0, 0, 0, 0}
  },
  {
   {0, 0, 0, 1},
   {0, 1, 1, 1},
   {0, 0, 0, 0},
   {0, 0, 0, 0}
  }
 },
 { -- s type
  {
   {0, 0, 1, 1},
   {0, 1, 1, 0},
   {0, 0, 0, 0},
   {0, 0, 0, 0}
  },
  {
   {0, 1, 0, 0},
   {0, 1, 1, 0},
   {0, 0, 1, 0},
   {0, 0, 0, 0}
  },
  {
   {0, 0, 1, 1},
   {0, 1, 1, 0},
   {0, 0, 0, 0},
   {0, 0, 0, 0}
  },
  {
   {0, 1, 0, 0},
   {0, 1, 1, 0},
   {0, 0, 1, 0},
   {0, 0, 0, 0}
  }
 },
 { -- z type
  {
   {0, 1, 1, 0},
   {0, 0, 1, 1},
   {0, 0, 0, 0},
   {0, 0, 0, 0}
  },
  {
   {0, 0, 1, 0},
   {0, 1, 1, 0},
   {0, 1, 0, 0},
   {0, 0, 0, 0}
  },
  {
   {0, 1, 1, 0},
   {0, 0, 1, 1},
   {0, 0, 0, 0},
   {0, 0, 0, 0}
  },
  {
   {0, 0, 1, 0},
   {0, 1, 1, 0},
   {0, 1, 0, 0},
   {0, 0, 0, 0}
  }
 },
 { -- t type
  {
   {0, 0, 1, 0},
   {0, 1, 1, 1},
   {0, 0, 0, 0},
   {0, 0, 0, 0}
  },
  {
   {0, 0, 1, 0},
   {0, 0, 1, 1},
   {0, 0, 1, 0},
   {0, 0, 0, 0}
  },
  {
   {0, 1, 1, 1},
   {0, 0, 1, 0},
   {0, 0, 0, 0},
   {0, 0, 0, 0}
  },
  {
   {0, 0, 1, 0},
   {0, 1, 1, 0},
   {0, 0, 1, 0},
   {0, 0, 0, 0}
  }
 }
}

function _init()
 current_piece=new_piece()

 blk_size=8
 frame=0
 gravity=20
 bottom=128-(blk_size) 
 right_edge=(blk_size*10-blk_size)
 blocks={}
 game_over=false
 game_over_sound_playing=false
end

function _update()
 if(not game_over) then
  tick()
  handle_input()
 end
end

function _draw()
 cls()
 rect(0,0,blk_size*10, bottom,7)
 draw_piece(current_piece)
 foreach(blocks, draw_block)
 if game_over then
  print("game over", 70, 24, 8)
  if not game_over_sound_playing then
   sfx(0)
   game_over_sound_playing=true
  end
 end
end

function tick() 
 frame+=1
 if frame % gravity == 0 then
  if hit_bottom(current_piece) then
   save_piece(current_piece)
   current_piece=new_piece()
   if (hit_bottom(current_piece)) game_over=true
  else
   fall(current_piece)
  end
 end
end

function handle_input()
 if btnp(0) and can_move_left(current_piece) then
  current_piece.x -= blk_size -- left
 elseif btnp(1) and can_move_right(current_piece) then
  current_piece.x+=blk_size -- right
 elseif btnp(2) then
  current_piece=rotate(current_piece)
 elseif btn(3) then
  fall(current_piece)
 elseif btn(4) or btn(5) then
  hard_drop(current_piece)
 end
end

function rotate(piece)
 piece.rotation+=1
 if (piece.rotation > 4) piece.rotation = 1
 return piece
end

function fall(block)
 if not hit_bottom(block) then
  block.y+=blk_size
 end
end

function hard_drop(block)
 repeat
  fall(block)
 until hit_bottom(block)
end

function save_piece(piece)
 for row=1,4 do
  for col=1,4 do
   if tetrinos[piece.type][piece.rotation][row][col] == 1 then
    local player_block = {x=piece.x + ((row-1)*blk_size), y=piece.y + ((col-1)*blk_size), color=piece.color}
    add(blocks, player_block)
   end
  end
 end
end

function hit_bottom(piece)
 for row=1,4 do
  for col=1,4 do
   if tetrinos[piece.type][piece.rotation][row][col] == 1 then
    local player_block = {x=piece.x + ((row-1)*blk_size), y=piece.y + ((col-1)*blk_size)}
    local min_y=bottom
    for b in all(blocks) do
     if (b.x == player_block.x) min_y=min(min_y, b.y)
    end
    if (player_block.y == min_y-blk_size) return true
   end
  end
 end 
 return false
end

function can_move_right(piece)
 for row=1,4 do
  for col=1,4 do
   if tetrinos[piece.type][piece.rotation][row][col] == 1 then
    local player_block = {x=piece.x + ((row-1)*blk_size), y=piece.y + ((col-1)*blk_size)}
    if player_block.x < right_edge then
     for b in all(blocks) do
      if (b.y == player_block.y and b.x == player_block.x+blk_size) return false
     end
    else 
     return false
    end
   end
  end
 end 
 return true
end


function can_move_left(piece)
 for row=1,4 do
  for col=1,4 do
   if tetrinos[piece.type][piece.rotation][row][col] == 1 then
    local player_block = {x=piece.x + ((row-1)*blk_size), y=piece.y + ((col-1)*blk_size)}
    if player_block.x > 0 then
     for b in all(blocks) do
      if (b.y == player_block.y and b.x == player_block.x-blk_size) return false
     end
    else 
     return false
    end
   end
  end
 end 
 return true
end

function draw_piece(piece) 
 for row=1,4 do
  for col=1,4 do
   if tetrinos[piece.type][piece.rotation][row][col] == 1 then
    draw_block({x=piece.x + ((row-1)*blk_size), y=piece.y + ((col-1)*blk_size), color=piece.color})
   end
  end
 end 
end


function draw_block(block)
 rect(block.x, block.y, block.x+blk_size, block.y+blk_size, 7)
 rectfill(block.x+1, block.y+1, block.x+blk_size-1, block.y+blk_size-1, block.color)
end

function new_piece()
 return {x=32, y=0, color=rnd(14)+2, type=flr(rnd(7))+1, rotation=1} -- no black or dark blue blocks
end

__gfx__
00000000777777770000000070000000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000711111110000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700711111110000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000711111110000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000711111110000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700711111110000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000711111110000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000711111110000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0101010101010101010103000000000001010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010103000000000001010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010103000000000001010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010103000000000001010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010103000000000001010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010103000000000001000101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010103000000000001010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010103000000000001010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010103000000000001010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010103000000000001010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010103000000000001010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010103000000000001010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010103000000000001010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010103000000000001010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010103000000000001010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040404040404040405000000000001010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404010101010101000000000001010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000001010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010e00000f7500f7300e7500e7300d7500d7300c7500c7300b7550b7550a7550a7550975509755087550875507755137550000000000000000000000000000000000000000000000000000000000000000000000
