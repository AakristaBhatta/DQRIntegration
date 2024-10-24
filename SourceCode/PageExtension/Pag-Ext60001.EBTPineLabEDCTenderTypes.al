pageextension 60001 "EBT Pine Lab EDC Tender Types" extends "LSC Tender Type List"
{
    layout
    {
        addafter("Foreign Currency")
        {
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

        }
    }
}
