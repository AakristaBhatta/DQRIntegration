table 60001 "EBT Pinelab EDC Response Log"
{
    Caption = 'Innoviti EDC Response Log';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Billing Reference No."; Code[250])
        {
            Caption = 'Billing Reference No.';
        }
        field(3; "Approval Code"; Code[250])
        {
            Caption = 'Approval Code';
        }
        field(4; "Host Response"; Text[250])
        {
            Caption = 'Host Response';
        }
        field(5; "Card Number"; Text[250])
        {
            Caption = 'Card Number';
        }
        field(6; "Expiration Date"; text[250])
        {
            Caption = 'Expiration Date';
        }
        field(7; "CardHolder's Name"; Text[250])
        {
            Caption = 'CardHolder''s Name';
        }
        field(8; "Card Type"; Text[250])
        {
            Caption = 'Card Type';
        }
        field(9; "Invoice Number"; Code[250])
        {
            Caption = 'Invoice Number';
        }
        field(10; "Batch Number"; Integer)
        {
            Caption = 'Batch Number';
        }
        field(11; "Terminal Id"; Text[250])
        {
            Caption = 'Terminal Id';
        }
        field(12; "Loyalty Points Awarded"; Integer)
        {
            Caption = 'Loyalty Points Awarded';
        }
        field(13; Remarks; Text[250])
        {
            Caption = 'Remarks';
        }
        field(23; "Transaction Acquirer Name"; Text[250])
        {
            Caption = 'Transaction Acquirer Name';
        }
        field(14; "Response Log"; Blob)
        {
            Caption = 'Response Log';
        }
        field(15; "Merchant ID"; Text[250])
        {
            Caption = 'Merchant ID';
        }
        field(16; "Retrieval Reference Number"; Text[250])
        {
            Caption = 'Retrieval Reference Number';
        }
        field(17; "Print CardHolder's Name On Rpt"; Integer)
        {
            Caption = 'Print CardHolder''s Name On Receipt';
        }
        field(18; "Merchant Name"; Text[250])
        {
            Caption = 'Merchant Name';
        }
        field(19; "Merchant Address"; Text[250])
        {
            Caption = 'Merchant Address';
        }
        field(20; "Merchant City"; Text[250])
        {
            Caption = 'Merchant City';
        }
        field(21; "Card Entry Mode"; Integer)
        {
            Caption = 'Card Entry Mode';
        }
        field(22; "Plutus Version"; Text[250])
        {
            Caption = 'Plutus Version';
        }

    }
    keys
    {
        key(PK; "Billing Reference No.", "Approval Code", "Entry No.")
        {
            Clustered = true;
        }

    }
    trigger OnInsert()
    var
        ResponseLog: Record "EBT Pinelab EDC Response Log";
    begin

        ResponseLog.SetRange("Billing Reference No.", "Billing Reference No.");
        ResponseLog.SetRange("Approval Code", "Approval Code");
        if ResponseLog.FindLast() then
            "Entry No." := ResponseLog."Entry No." + 1
        else
            "Entry No." := 1;
    end;

    procedure GetReceiptXMLData() ReceiptXMLData: Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        // CalcFields("Response Log");
        // "Response Log".CreateInStream(InStream, TEXTENCODING::UTF8);
        // exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), FieldName("Receipt XML Data")));
    end;
}
