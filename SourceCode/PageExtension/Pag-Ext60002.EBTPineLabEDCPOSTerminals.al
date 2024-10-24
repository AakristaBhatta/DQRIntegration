pageextension 60002 "EBT PineLab EDC POSTerminals" extends "LSC POS Terminal List"
{
    layout
    {
        addafter("Terminal Type")
        {

            field("EBT Pinelab EDC Device IP"; Rec."EBT Pinelab EDC Device IP")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the EBT Innoviti EDC Device IP Address field.';
            }
            field("EBT Pinelab EDC Device Port"; Rec."EBT Pinelab EDC Device Port")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the EBT Innoviti EDC Device Port field.';
            }
        }
    }
}
