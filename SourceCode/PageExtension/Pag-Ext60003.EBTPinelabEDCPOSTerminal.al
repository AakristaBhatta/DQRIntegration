pageextension 60003 "EBT Pinelab EDC POSTerminal" extends "LSC POS Terminal Card"
{
    layout
    {
        addafter("LS Recommend")
        {
            group(EBTPineLabIntegration)
            {
                Caption = 'PineLab EDC Integration';
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
}