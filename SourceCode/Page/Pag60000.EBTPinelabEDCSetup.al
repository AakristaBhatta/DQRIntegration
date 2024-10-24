page 60000 "EBT Pinelab EDC Setup"
{
    ApplicationArea = ALL;
    UsageCategory = Administration;
    InsertAllowed = false;
    Caption = 'Pinelab EDC Setup';
    PageType = Card;
    SourceTable = "EBT Pinelab EDC Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Base URL"; Rec."Base URL")
                {
                    ToolTip = 'Specifies the value of the Base URL field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group(Logs)
            {
                Caption = 'Logs';
                action(ResponseLog)
                {
                    Caption = 'Response Log';
                    Image = CreditCardLog;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        Page.Run(Page::"EBT Pinelab EDC Response Log");
                    end;
                }
            }
            group(Configure)
            {
                Caption = 'Configure';
                action(RegisterCommands)
                {
                    ApplicationArea = All;
                    Caption = 'Register Innoviti EDC Commands';
                    PromotedCategory = Process;
                    Promoted = true;
                    Image = Accounts;
                    trigger OnAction()
                    var
                        MenuLine: Record "LSC POS Menu Line";
                    begin
                        MenuLine."Registration Mode" := true;
                        Codeunit.Run(Codeunit::"EBT PineLabs EDC Commands", MenuLine);
                    end;
                }
                action(StoreList)
                {
                    Caption = 'Store List';
                    Image = ShowInventoryPeriods;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        Page.Run(Page::"LSC Store List");
                    end;
                }
                action(TenderTypes)
                {
                    Caption = 'Tender Types';
                    Image = CashFlowSetup;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        Page.Run(Page::"LSC Tender Type List");
                    end;
                }
                action(TerminalList)
                {
                    Caption = 'POS Terminal';
                    Image = MapSetup;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        Page.Run(Page::"LSC POS Terminal List");
                    end;
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec."Base URL" := 'http://%1:%2/1/request';
            Rec.Insert();
        end;
    end;
}
