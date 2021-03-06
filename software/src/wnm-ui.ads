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

with Ada.Interrupts.Names;

with STM32.Device; use STM32.Device;
with STM32.GPIO;   use STM32.GPIO;
with STM32.Timers; use STM32.Timers;
with STM32.PWM;    use STM32.PWM;

package WNM.UI is

   procedure Start;

   function Is_Pressed (B : Buttons) return Boolean;

   procedure Turn_On (B : LEDs);
   procedure Turn_Off (B : LEDs);

private

   Key_To_Point : constant array (Buttons) of GPIO_Point :=
     (B1        => PC1,
      B2        => PA2,
      B3        => PC4,
      B4        => PE7,
      B5        => PE11,
      B6        => PE15,
      B7        => PB13,
      B8        => PD9,
      B9        => PC3,
      B10       => PA3,
      B11       => PC5,
      B12       => PE8,
      B13       => PE12,
      B14       => PB10,
      B15       => PB12,
      B16       => PD10,
      Rec       => PA10,
      Play      => PC6,
      FX        => PD15,
      Chan_A    => PB1,
      Chan_B    => PE10,
      Chan_C    => PE14,
      Chan_D    => PB14,
      Chan_E    => PD8,
      Encoder_L => PC14,
      Encoder_R => PC15);

   Wakeup : GPIO_Point renames PA0;

   type Row_Index is range 1 .. 3;
   type Col_Index is range 1 .. 9;

   Row_To_Point : array (Row_Index) of GPIO_Point :=
     (1 => PD13,
      2 => PD12,
      3 => PD11);

   Col_To_Point : array (Col_Index) of GPIO_Point :=
     (1 => PC0,
      2 => PC2,
      3 => PA4,
      4 => PB0,
      5 => PE9,
      6 => PE13,
      7 => PB11,
      8 => PB15,
      9 => PD14);

   type LED_Address is record
      Row : Row_Index;
      Col : Col_Index;
   end record;

   Key_To_LED : constant array (LEDs) of LED_Address :=
     (B1      => (Row => 2, Col => 1),
      B2      => (Row => 2, Col => 2),
      B3      => (Row => 2, Col => 3),
      B4      => (Row => 2, Col => 4),
      B5      => (Row => 2, Col => 5),
      B6      => (Row => 2, Col => 6),
      B7      => (Row => 2, Col => 7),
      B8      => (Row => 2, Col => 8),
      B9      => (Row => 1, Col => 1),
      B10     => (Row => 1, Col => 2),
      B11     => (Row => 1, Col => 3),
      B12     => (Row => 1, Col => 4),
      B13     => (Row => 1, Col => 5),
      B14     => (Row => 1, Col => 6),
      B15     => (Row => 1, Col => 7),
      B16     => (Row => 1, Col => 8),
      Rec     => (Row => 1, Col => 9),
      Play    => (Row => 2, Col => 9),
      FX      => (Row => 3, Col => 9),
      Chan_A  => (Row => 3, Col => 4),
      Chan_B  => (Row => 3, Col => 5),
      Chan_C  => (Row => 3, Col => 6),
      Chan_D  => (Row => 3, Col => 7),
      Chan_E  => (Row => 3, Col => 8));

   LED_State : array (Buttons) of Boolean := (others => False);

   type Buttton_Event is (On_Press,
                          On_Long_Press,
                          On_Release,
                          Waiting_For_Long_Press);
   type Raw_Key_State is (Up, Down);

   Key_State : array (Buttons) of Raw_Key_State := (others => Up);
   --  FIXME: This array stays here for external access to the button state.
   --  In the future we shouldn't have to export this info, the array could
   --  then be moved in UI_Task.

   Has_Long_Press : constant array (Buttons) of Boolean :=
   --  Can this button trigger a On_Long_Press event?
     (B1        => False,
      B2        => False,
      B3        => False,
      B4        => False,
      B5        => False,
      B6        => False,
      B7        => False,
      B8        => False,
      B9        => False,
      B10       => False,
      B11       => False,
      B12       => False,
      B13       => False,
      B14       => False,
      B15       => False,
      B16       => False,
      Rec       => True,
      Play      => False,
      FX        => False,
      Chan_A    => True,
      Chan_B    => True,
      Chan_C    => True,
      Chan_D    => True,
      Chan_E    => True,
      Encoder_L => True,
      Encoder_R => True);

   LED_Timer : STM32.Timers.Timer renames Timer_7;
   LED_Timer_Control : PWM_Modulator;

   protected LED_Timer_Handler is
      pragma Interrupt_Priority;

   private

      Current_LED : LEDs := Buttons'First;
      procedure IRQ_Handler;
      pragma Attach_Handler (IRQ_Handler, Ada.Interrupts.Names.TIM7_Interrupt);

   end LED_Timer_Handler;

end WNM.UI;
