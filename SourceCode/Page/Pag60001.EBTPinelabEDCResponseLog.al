page 60001 "EBT Pinelab EDC Response Log"
{
    ApplicationArea = All;
    Caption = 'Pinelab EDC Response Log';
    PageType = List;
    SourceTable = "EBT Pinelab EDC Response Log";
    SourceTableView = sorting("Entry No.") order(descending);
    UsageCategory = Lists;
    Editable = true;
    DeleteAllowed = true;
    InsertAllowed = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {

                field("Approval Code"; Rec."Approval Code")
                {
                    ToolTip = 'Specifies the value of the Approval Code field.', Comment = '%';
                }
                field("Batch Number"; Rec."Batch Number")
                {
                    ToolTip = 'Specifies the value of the Batch Number field.', Comment = '%';
                }
                field("Billing Reference No."; Rec."Billing Reference No.")
                {
                    ToolTip = 'Specifies the value of the Billing Reference No. field.', Comment = '%';
                }
                field("Card Entry Mode"; Rec."Card Entry Mode")
                {
                    ToolTip = 'Specifies the value of the Card Entry Mode field.', Comment = '%';
                }
                field("Card Number"; Rec."Card Number")
                {
                    ToolTip = 'Specifies the value of the Card Number field.', Comment = '%';
                }
                field("Card Type"; Rec."Card Type")
                {
                    ToolTip = 'Specifies the value of the Card Type field.', Comment = '%';
                }
                field("CardHolder's Name"; Rec."CardHolder's Name")
                {
                    ToolTip = 'Specifies the value of the CardHolder''s Name field.', Comment = '%';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ToolTip = 'Specifies the value of the Expiration Date field.', Comment = '%';
                }
                field("Host Response"; Rec."Host Response")
                {
                    ToolTip = 'Specifies the value of the Host Response field.', Comment = '%';
                }
                field("Invoice Number"; Rec."Invoice Number")
                {
                    ToolTip = 'Specifies the value of the Invoice Number field.', Comment = '%';
                }
                field("Loyalty Points Awarded"; Rec."Loyalty Points Awarded")
                {
                    ToolTip = 'Specifies the value of the Loyalty Points Awarded field.', Comment = '%';
                }
                field("Merchant Address"; Rec."Merchant Address")
                {
                    ToolTip = 'Specifies the value of the Merchant Address field.', Comment = '%';
                }
                field("Merchant City"; Rec."Merchant City")
                {
                    ToolTip = 'Specifies the value of the Merchant City field.', Comment = '%';
                }
                field("Merchant ID"; Rec."Merchant ID")
                {
                    ToolTip = 'Specifies the value of the Merchant ID field.', Comment = '%';
                }
                field("Merchant Name"; Rec."Merchant Name")
                {
                    ToolTip = 'Specifies the value of the Merchant Name field.', Comment = '%';
                }
                field("Plutus Version"; Rec."Plutus Version")
                {
                    ToolTip = 'Specifies the value of the Plutus Version field.', Comment = '%';
                }
                field("Print CardHolder's Name On Rpt"; Rec."Print CardHolder's Name On Rpt")
                {
                    ToolTip = 'Specifies the value of the Print CardHolder''s Name On Receipt field.', Comment = '%';
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.', Comment = '%';
                }
                field("Response Log"; Rec."Response Log")
                {
                    ToolTip = 'Specifies the value of the Response Log field.', Comment = '%';
                }
                field("Retrieval Reference Number"; Rec."Retrieval Reference Number")
                {
                    ToolTip = 'Specifies the value of the Retrieval Reference Number field.', Comment = '%';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.', Comment = '%';
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.', Comment = '%';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.', Comment = '%';
                }
                field("Terminal Id"; Rec."Terminal Id")
                {
                    ToolTip = 'Specifies the value of the Terminal Id field.', Comment = '%';
                }
                field("Transaction Acquirer Name"; Rec."Transaction Acquirer Name")
                {
                    ToolTip = 'Specifies the value of the Transaction Acquirer Name field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action(ReceiptData)
            {
                Caption = 'Receipt XML Data';
                Image = XMLFileGroup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
                trigger OnAction()
                var
                    ResponseText: Text;
                begin
                    //Message('%1', rec.GetReceiptXMLData());
                    // ResponseText := DelChr(Rec.GetReceiptXMLData(), '=', '/');
                    // Message(ResponseText);
                    ParseCSVResponse(Rec.GetReceiptXMLData());
                end;
            }
        }
    }
    procedure ParseCSVResponse(response: Text)
    var
        CsvLine: Text;
        CsvFields: List of [Text];
        Separator: Text;
        i: Integer;
        Field: Text;
    begin
        // Define the separator
        Separator := ',';

        // Split the response string by lines (in this case, it's just one line)
        CsvLine := response;
        // Message(response);
        // Use the Text.Split function to split the CSV line into fields
        CsvFields := CsvLine.Split(Separator);
        // Message(Format(CsvFields));
        // Loop through the fields and display them
        foreach field in csvFields do begin
            i += 1;
            Field := DelChr(Field, '=', '/');
            Field := DelChr(Field, '=', '\');
            Field := DelChr(Field, '=', '"');
            Message('Field %1: %2', i, Field);
        end;
        // for i := 0 to CsvFields.Count() - 1 do begin
        //     // Trim any leading or trailing whitespace
        //     // CsvFields[i] := CsvFields[i].Trim();
        //     // Display each field (or process it as needed)
        //     CsvFields.Get(i, Field);
        //     // Trim any leading or trailing whitespace
        //     // Field := Field.Trim();
        //     // Display each field (or process it as needed)
        //     Message('Field %1: %2', i + 1, Field);
        // end;
    end;

}
