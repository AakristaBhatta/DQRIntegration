pageextension 60000 "EBT Pinelab EDC Tender Type" extends "LSC Tender Type Card"
{
    layout
    {
        addafter(Declaration)
        {
            group(PinelabIntegration)
            {
                Caption = 'Pinelab EDC Integration';
                field("EBT Pinelab EDC Tender"; Rec."EBT Pinelab EDC Tender")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Innoviti EDC Tender field.';
                }
                field("EBT Pinelab Request Mode"; Rec."EBT Pinelab Request Mode")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Innoviti Request Mode field.';
                }
                field("EBT PinelabWaiting Message"; Rec."EBT PinelabWaiting Message")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Waiting Message field.';
                }
            }
        }
    }
}
