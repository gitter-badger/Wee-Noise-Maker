-------------------------------------------------------------------------------
--                                                                           --
--                              Wee Noise Maker                              --
--                                                                           --
--                  Copyright (C) 2016-2017 Fabien Chouteau                  --
--                                                                           --
--    Wee Noise Maker is free software: you can redistribute it and/or       --
--    modify it under the terms of the GNU General Public License as         --
--    published by the Free Software Foundation, either version 3 of the     --
--    License, or (at your option) any later version.                        --
--                                                                           --
--    Wee Noise Maker is distributed in the hope that it will be useful,     --
--    but WITHOUT ANY WARRANTY; without even the implied warranty of         --
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU       --
--    General Public License for more details.                               --
--                                                                           --
--    You should have received a copy of the GNU General Public License      --
--    along with We Noise Maker. If not, see <http://www.gnu.org/licenses/>. --
--                                                                           --
-------------------------------------------------------------------------------

with Ada.Real_Time; use Ada.Real_Time;

--  with WNM.Sequencer;
with WNM.UI;
with WNM.Encoders;
with WNM.Screen;
with WNM.I2C;

procedure Main is
   pragma Priority (WNM.Synth_Task_Priority);
begin

   WNM.I2C.Initialize;
   WNM.Screen.Initialize;
   WNM.Encoders.Initialize;

--     WNM.Sequencer.Start;
   WNM.UI.Start;

   --  Wait forever...
   delay until Time_Last;

end Main;
