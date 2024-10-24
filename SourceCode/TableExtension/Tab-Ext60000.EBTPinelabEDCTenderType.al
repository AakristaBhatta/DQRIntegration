tableextension 60000 "EBT Pinelab EDC Tender Type" extends "LSC Tender Type"
{
    fields
    {
        field(60000; "EBT Pinelab EDC Tender"; Boolean)
        {
            Caption = 'Pinelab EDC Tender';
            DataClassification = CustomerContent;
        }
        field(60001; "EBT Pinelab Request Mode"; Text[4])
        {
            Caption = 'Pinelab Request Mode';
            DataClassification = CustomerContent;
        }
        field(60002; "EBT PinelabWaiting Message"; Text[1024])
        {
            Caption = 'PinelabWaiting Message';
            DataClassification = CustomerContent;
        }
    }
}
