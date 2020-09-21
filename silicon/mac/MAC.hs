module Silicon.MAC where

import Clash.Prelude
import Silicon.Two

ma acc (x, y) = acc + Silicon.Two.z(x * y)

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