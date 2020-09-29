module Silicon.MAC.MAC where

import Clash.Prelude
import Silicon.Two.Two

ma acc (x, y) = acc + Silicon.Two.Two.z(x * y) * 4

triple inp = 3 * inp

macT acc (x, y) = (triple(acc'), o)
  where
    acc' = ma acc (x,y)
    o = acc

mac = mealy macT 0

topEntity
  :: Clock System
  -> Reset System
  -> Enable System
  -> Signal System (Signed 9, Signed 9)
  -> Signal System (Signed 9)
topEntity = exposeClockResetEnable mac