tableextension 60001 "EBT Pinelab EDC POS Terminal" extends "LSC POS Terminal"
{
    fields
    {
        field(60000; "EBT Pinelab EDC Device IP"; Text[50])
        {
            Caption = 'Pinelab Device IP Address';
            DataClassification = CustomerContent;
        }
        field(60001; "EBT Pinelab EDC Device Port"; Text[10])
        {
            Caption = 'Pinelab Device Port';
            DataClassification = CustomerContent;
        }
    }
}
