codeunit 60003 "EBT PineLabs EDC Commands"
{
    TableNo = "LSC POS Menu Line";

    var
        GlobalRec: Record "LSC POS Menu Line";
        CommandFunc: Codeunit "LSC POS Command Registration";
        PinelabCardLbl: Label 'EBT_Pinn_Card_Wired';
        PineLabUPILbl: Label 'EBT_Pinn _UPI_Wired';
        PineLabLastTransaction: Label 'EBT_Pinn_LastTransaction';
        ModuleLbl: Label 'EBT_Pinelab';
        ModuleNameLbl: Label 'EBT PineLab EDC';


    trigger OnRun()
    begin
        GlobalRec := Rec;

        if Rec."Registration Mode" then
            Register(Rec)
        else begin
            case Rec.Command of
                PinelabCardLbl:
                    begin
                        ProcessInnovitiCard(Rec);
                    end;
                PineLabUPILbl:
                    begin
                        ProcessInnovitiUPI(Rec);
                    end;
                PineLabLastTransaction:
                    begin
                        ProcessLastTransactionUPI(Rec);
                    end;
            end;
            Rec := GlobalRec;
        end;
    end;

    internal procedure GetModuleName(): Text
    begin
        exit(ModuleLbl);
    end;

    local procedure ProcessInnovitiCard(Rec: Record "LSC POS Menu Line")
    begin
        ProcessInnovitiPayment(Rec);
    end;

    local procedure ProcessInnovitiUPI(Rec: Record "LSC POS Menu Line")
    begin
        ProcessInnovitiPayment(Rec);
    end;

    local procedure ProcessLastTransactionUPI(rec: Record "LSC POS Menu Line")
    begin
        ProcessInnovitiPayment(rec);
    end;

    local procedure ProcessInnovitiPayment(Rec: Record "LSC POS Menu Line")
    var
        POSTrans: Record "LSC POS Transaction";
        EDCHelpers: codeunit "EBT Plutus EDC Event Helpers";
        TenderType: Record "LSC Tender Type";
        TenderAmount: Decimal;
        TenderAmountText: Text;
        CurrInput: Text;
        EDCTendorNotFoundErr: Label 'Tender Type %1 could not be found for store %2.';
        ParameterBlankErr: Label 'Command must have parameter. And this parameter must be same as Tender Type Code.';
    begin
        Rec.Processed := true;
        if rec.Parameter = '' then
            Error(ParameterBlankErr);
        if not POSTrans.Get(rec."Current-RECEIPT") then
            exit;
        POSTrans.CalcFields("Gross Amount", Payment);
        TenderAmount := (POSTrans."Gross Amount" - POSTrans.Payment);
        if TenderAmount <= 0 then
            exit;
        TenderAmountText := Format(TenderAmount);
        TenderType.Reset();
        TenderType.SetRange("Store No.", POSTrans."Store No.");
        TenderType.SetRange(Code, rec.Parameter);
        TenderType.SetRange("EBT Pinelab EDC Tender", true);
        if not TenderType.FindFirst() then
            Error(EDCTendorNotFoundErr);
        EDCHelpers.ProcessInnovitiPayment(POSTrans, CurrInput, TenderType.Code, TenderAmountText);
    end;


    procedure Register(var MenuLine: Record "LSC POS Menu Line")
    var
        ParameterType: Enum "LSC POS Command Parameter Type";
        AutoRegLbl: Label 'PineLab EDC Command has been registerd. Now bind these commands with the buttons along with the parameters. Parameter defined must be equal to Tender Type Code.';
    begin
        CommandFunc.RegisterModule(ModuleLbl, ModuleNameLbl, 60003);
        CommandFunc.RegisterExtCommand(PinelabCardLbl, 'PineLab Card Payment', 60003, ParameterType::" ", ModuleLbl, true);
        CommandFunc.RegisterExtCommand(PineLabUPILbl, 'PineLab UPI Payment', 60003, ParameterType::" ", ModuleLbl, true);
        CommandFunc.RegisterExtCommand(PineLabLastTransaction, 'Pinelab Last Transaction UPI Payment', 60003, ParameterType::" ", ModuleLbl, true);
        Message(AutoRegLbl);
    end;


}