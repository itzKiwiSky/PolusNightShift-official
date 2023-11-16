local collision = {}   -- Returned collision table
local distance = nil   -- Funciton that gets distance between two points


--                     --
-------------------------
-- COLLISION FUNCTIONS --
-------------------------
--                     --

function collision.pointPoint(point1, point2)
  if point1.x == point2.x and point1.y == point2.y
  then return true end

  return false
end

function collision.rectRect(rect1, rect2)
  if rect1.x + rect1.w > rect2.x and       -- right  rect1 > left   rect2
     rect1.y + rect1.h > rect2.y and       -- bottom rect1 > top    rect2
     rect1.x < rect2.x + rect2.w and       -- left   rect1 > left   rect2
     rect1.y < rect2.y + rect2.h           -- top    rect1 > bottom rect2
  then return true end

  return false
end

function collision.pointRect(point, rect)
  if point.x > rect.x and
     point.y > rect.y and
     point.x < rect.x + rect.w and
     point.y < rect.y + rect.h
  then return true end

  return false
end

function collision.circCirc(circ1, circ2)
  if distance(circ1, circ2) < circ1.r+circ2.r then
    return true
  end
  return false
end

function collision.pointCirc(point, circ)
  if distance(point, circ) < circ.r then
    return true
  end
  return false
end

function collision.circRect(circ, rect)

  local test = {x, y}
  test.x = circ.x
  test.y = circ.y

  -- Find closest edges to check against
  if circ.x < rect.x then
    test.x = rect.x          -- left edge
  elseif circ.x > rect.x+rect.w then
    test.x = rect.x+rect.w   -- right edge
  end

  if circ.y < rect.y then
    test.y = rect.y          -- top edge
  elseif circ.y > rect.y+rect.h then
    test.y = rect.y+rect.h   -- bottom edge
  end

  if distance(circ, test) < circ.r then
    return true
  end
  return false
end

function collision.pointSeg(point, seg, buffer)
  -- Set buffer to zero if undefined
  if type(buffer) == "nil" then
    buffer = 0
  end

  -- The two points that make up a segment
  local lp1 = {x=seg.x1, y=seg.y1}
  local lp2 = {x=seg.x2, y=seg.y2}

  -- Distance between our point and our seg points
  local d1 = distance(point, lp1) -- Point to one seg point
  local d2 = distance(point, lp2) -- Point to other seg point
  local d3 = distance(lp1,   lp2) -- Line length

  if d1+d2 >= d3-buffer and d1+d2 <= d3+buffer then
    return true
  end
  return false
end

-- @incomplete @temporary:
-- This isn't perfect, the end points of a segement have a small issue. The
-- issue is that a segment with a larger width doesn't cleanly do pointCirc
-- collision for the segements ends. I would need to do circle collision with
-- rotated rectangle for an exact collision.
function collision.segCirc(seg, circ, buffer)
  -- Set buffer to zero if undefined
  if type(buffer) == "nil" then
    buffer = 0
  end

  -- Circle with buffer added to radius
  bCirc = {}
  bCirc.r = circ.r+buffer
  bCirc.x = circ.x
  bCirc.y = circ.y

  -- The two points that make up a segment
  local lp1 = {x=seg.x1, y=seg.y1}
  local lp2 = {x=seg.x2, y=seg.y2}

  -- Check if collision with either point on the segment
  if collision.pointCirc(lp1, bCirc) or collision.pointCirc(lp2, bCirc) then
    return true
  end

  local distX = lp1.x - lp2.x
  local distY = lp1.y - lp2.y
  local len = math.sqrt( (distX*distX) + (distY*distY) )

  -- Dot product of segment and circle
  local dot = (
    ((bCirc.x-lp1.x)*(lp2.x-lp1.x)) + ((bCirc.y-lp1.y)*(lp2.y-lp1.y))
  ) / math.pow(len,2)

  local closest = {}
  closest.x = lp1.x + (dot * (lp2.x-lp1.x))
  closest.y = lp1.y + (dot * (lp2.y-lp1.y))

  -- Make sure you are on the segment
  if not collision.pointSeg(closest, seg) then
    return false
  end

  if distance(bCirc, closest) <= bCirc.r then
    return true;
  end
  return false;
end

-- Need to figure out how these return types should work for
-- different collisions
function collision.lineLine(line1, line2)
  -- This is a standard form calculation

  local A1 = line1.y2 - line1.y1
  local B1 = line1.x1 - line1.x2
  local C1 = A1 * line1.x1 + B1 * line1.y1

  local A2 = line2.y2 - line2.y1
  local B2 = line2.x1 - line2.x2
  local C2 = A2 * line2.x1 + B2 * line2.y1

  -- Same between lines so we just need one denominator
  local denominator = A1 * B2 - A2 * B1

  -- If the lines are parallel or colinear denominator is 0
  if denominator == 0 then
    print "Parallel"

    if A1/C1 == A2/C2 and B1/C1 == B2/C2 then
      print "Colinear"
    end
  end

  local intersectX = (B2 * C1 - B1 * C2) / denominator
  local intersectY = (A1 * C2 - A2 * C1) / denominator

  return intersectX, intersectY
end

function collision.segSeg(seg1, seg2)
  -- This is a standard form calculation

  local A1 = seg1.y2 - seg1.y1
  local B1 = seg1.x1 - seg1.x2
  local C1 = A1 * seg1.x1 + B1 * seg1.y1

  local A2 = seg2.y2 - seg2.y1
  local B2 = seg2.x1 - seg2.x2
  local C2 = A2 * seg2.x1 + B2 * seg2.y1

  -- Same between segs so we just need one denominator
  local denominator = A1 * B2 - A2 * B1

  -- If the segs are parallel or cosegar denominator is 0
  -- if denominator == 0 then
  --   print "Parallel"

  --   if A1/C1 == A2/C2 and B1/C1 == B2/C2 then
  --     print "Cosegar"
  --   end
  -- end

  local intersectX = (B2 * C1 - B1 * C2) / denominator
  local intersectY = (A1 * C2 - A2 * C1) / denominator

  local rx1 = (intersectX - seg1.x1) / (seg1.x2 - seg1.x1)
  local ry1 = (intersectY - seg1.y1) / (seg1.y2 - seg1.y1)

  local rx2 = (intersectX - seg2.x1) / (seg2.x2 - seg2.x1)
  local ry2 = (intersectY - seg2.y1) / (seg2.y2 - seg2.y1)

  if (rx1 >= 0 and rx1 <= 1) or (ry1 >= 0 and ry1 <= 1) then
     if (rx2 >= 0 and rx2 <= 1) or (ry2 >= 0 and ry2 <= 1) then
      return true
    end
  end
  return false
end

-- function collision.segSeg(line1, line2, buffer1, buffer2)
--   local uA = (
--     (line2.x2-line2.x1)*(line1.y1-line2.y1) - (line2.y2-line2.y1)*(line1.x1-line2.x1)
--   ) / (
--     (line2.y2-line2.y1)*(line1.x2-line1.x1) - (line2.x2-line2.x1)*(line1.y2-line1.y1)
--   );

--   local uB = (
--     (line1.x2-line1.x1)*(line1.y1-line2.y1) - (line1.y2-line1.y1)*(line1.x1-line2.x1)
--   ) / (
--     (line2.y2-line2.y1)*(line1.x2-line1.x1) - (line2.x2-line2.x1)*(line1.y2-line1.y1)
--   );

--   if uA >= 0 and uA <= 1 and uB >= 0 and uB <= 1 then
--     return true;
--   end
--   return false
-- end


--                  --
----------------------
-- HELPER FUNCTIONS --
----------------------
--                  --
function distance(point1, point2)
  local px, py, dist
  px = math.abs(point1.x - point2.x)
  py = math.abs(point1.y - point2.y)
  dist = math.sqrt((px*px) + (py*py))

  return dist
end

return collision