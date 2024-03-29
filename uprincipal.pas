unit uprincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
   rxdbcurredit, rxdbgrid, rxmemds, RxDBGridFooterTools, rxcurredit,
  ZConnection, ZDataset, LCLType, ActnList, ACBrBAL;

type

{ TfrmPrincipal }

TfrmPrincipal = class(TForm)
  ACBrBAL1: TACBrBAL;
  actLePeso: TAction;
  ActionList1: TActionList;
  dsProduto: TDataSource;
  Memo1: TMemo;
  nQTDE: TCurrencyEdit;
  nUNIT: TCurrencyEdit;
  nSubTot: TCurrencyEdit;
  nTotalPed: TCurrencyEdit;
  dsItem: TDataSource;
  cCODIGO: TEdit;
  Label1: TLabel;
  Label2: TLabel;
  Label3: TLabel;
  Label4: TLabel;
  Label5: TLabel;
  Label6: TLabel;
  mdItemCODIGO: TLongintField;
  mdItemDESCRICAO: TStringField;
  mdItemITEM: TAutoIncField;
  mdItemQTDE: TFloatField;
  mdItemTOTAL: TCurrencyField;
  mdItemUNITARIO: TCurrencyField;
  Panel1: TPanel;
  pnpPESQUISA: TPanel;
  pnpDescricao: TPanel;
  mdItem: TRxMemoryData;
  qrProdutoBARRAS: TStringField;
  qrProdutoCODIGO: TLongintField;
  qrProdutoDESCRICAO: TStringField;
  qrProdutoPESAVEL: TStringField;
  qrProdutoVENDA: TFloatField;
  RxDBGrid1: TRxDBGrid;
  gridPESQUISA: TRxDBGrid;
  RxDBGridFooterTools1: TRxDBGridFooterTools;
  conexao: TZConnection;
  qrProduto: TZQuery;
  procedure ACBrBAL1LePeso(Peso: Double; Resposta: AnsiString);
  procedure actLePesoExecute(Sender: TObject);
  procedure btntesteClick(Sender: TObject);
  procedure cCODIGOKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  procedure cCODIGOKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  procedure FormCreate(Sender: TObject);
  procedure FormShow(Sender: TObject);
  procedure gridPESQUISAKeyDown(Sender: TObject; var Key: Word;
    Shift: TShiftState);
  procedure nQTDEKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
private
  procedure LimpaEdt;
  procedure IncluiItem;
  function pesquisa(cNOME:string):Boolean;
  function PesqProd(cTexto:string):boolean;
  function EtiquetaBal:boolean;
public

end;

var
  frmPrincipal: TfrmPrincipal;

implementation
uses typinfo,
ACBrUtil, ACBrDeviceSerial; {Para instalar o ACBr usando o Script do Ari, visite meu canal... www.youtube.com/infocotidiano}


{$R *.lfm}

{ TfrmPrincipal }

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  LimpaEdt;
  if not conexao.Connected then
     conexao.Connect;
end;

procedure TfrmPrincipal.gridPESQUISAKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_UP then
     begin
       if qrProduto.BOF then
          begin
          cCODIGO.SetFocus;
          end;
     end
  else if key= VK_RETURN then
     begin
       cCODIGO.Text := inttostr( qrProdutoCODIGO.Value);
       qrProduto.Close;
       pnpPESQUISA.Visible:=false;
       cCODIGO.SetFocus;
     end;

end;

procedure TfrmPrincipal.nQTDEKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_RETURN then
     begin
       if nQTDE.Value > 0 then
          begin
           IncluiItem;
          end
       else
          begin
             ShowMessage('L124 - A quantidade vendida invalida');
          end;
       cCODIGO.SetFocus;
     end;

end;

procedure TfrmPrincipal.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  if conexao.Connected then
     conexao.Disconnect;

end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
    LimpaEdt;
    nQTDE.Value:=0;
end;

procedure TfrmPrincipal.cCODIGOKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  nCODIGO : integer;
  nPeso   : real;
begin
  if key = VK_RETURN then
     begin
       if pnpPESQUISA.Visible then
          begin
            cCODIGO.Text:=inttostr(qrProdutoCODIGO.Value);
            qrProduto.Close;
            pnpPESQUISA.Visible:=false;
          end;
       if EtiquetaBal then
          abort;


       if PesqProd(cCODIGO.Text) then
          begin
            qrProduto.First;
            pnpDescricao.Caption:=qrProdutoDESCRICAO.Value;
            if qrProdutoPESAVEL.Value <> 'S' then
               nQTDE.Value:=1
            else
               begin
                 try
                 actLePeso.execute;
                 except
                   on e: Exception do
                     begin
                     ShowMessage('L173 - Erro ao ler o peso da balança'+sLineBreak +
                     'Verifique os cabos e se a balança esta ligada'+sLineBreak+
                     e.ClassName+sLineBreak+e.Message
                     );

                   nQTDE.Value:=0;
                   nQTDE.SetFocus;
                   end;
                 end;
               end;
            nUNIT.Value:=qrProdutoVENDA.Value;
            nQTDE.SetFocus;
          end
       else
          begin
              ShowMessage('L188 - produto não encontrado !');
              cCODIGO.SetFocus;
          end;
     end;

end;

procedure TfrmPrincipal.ACBrBAL1LePeso(Peso: Double; Resposta: AnsiString);
var valid : integer;
begin
   nQTDE.Value  := Peso;
//   sttResposta.Caption := Converte( Resposta ) ;

   if Peso > 0 then
      Memo1.Lines.Text := 'Leitura OK !'
   else
    begin
      valid := Trunc(ACBrBAL1.UltimoPesoLido);
      case valid of
         0 : Memo1.Lines.Text := 'TimeOut !'+sLineBreak+
                                 'Coloque o produto sobre a Balança!' ;
        -1 : Memo1.Lines.Text := 'Peso Instavel ! ' +sLineBreak+
                                 'Tente Nova Leitura' ;
        -2 : Memo1.Lines.Text := 'Peso Negativo !' ;
       -10 : Memo1.Lines.Text := 'Sobrepeso !' ;
      end;
    end ;
end;

procedure TfrmPrincipal.actLePesoExecute(Sender: TObject);
Var TimeOut : Integer ;
begin
  TimeOut := 2000 ;
   if not ACBrBAL1.Ativo then
      ACBrBAL1.ativar;
   try
   ACBrBAL1.LePeso( TimeOut );
   except
     showmessage('L226 - Erro ao ler o peso da balança!');
     nQTDE.Value:=0;
   end;
end;

procedure TfrmPrincipal.btntesteClick(Sender: TObject);
begin
  actLePeso.execute;
end;

procedure TfrmPrincipal.cCODIGOKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_DOWN then
     begin
       if pnpPESQUISA.Visible then
          gridPESQUISA.SetFocus;
     end;
  if Length(trim(cCODIGO.Text)) >= 3 then
     begin
       pesquisa(cCODIGO.Text);
     end
  else
     begin
       pnpPESQUISA.Visible:=false;
     end;
end;

procedure TfrmPrincipal.LimpaEdt;
begin
  cCODIGO.Clear;
  nQTDE.Clear;
  nUNIT.Clear;
  nSubTot.Clear;
 // nTotalPed.Clear;
end;

procedure TfrmPrincipal.IncluiItem;
begin
  try
  mdItem.Insert;
  mdItemCODIGO.Value   :=StrToInt(trim(cCODIGO.Text));
  mdItemDESCRICAO.Value:=pnpDescricao.Caption;
  mdItemQTDE.Value     :=nQTDE.Value;
  mdItemUNITARIO.Value :=nUNIT.Value;
  mdItemTOTAL.Value    := RoundABNT(nQTDE.Value * nUNIT.Value,2);
  mdItem.Post;
  nTotalPed.Value:=nTotalPed.Value+RoundABNT(nQTDE.Value * nUNIT.Value,2);
  LimpaEdt;
  except
    on e: exception do
       ShowMessage('L277 - Erro ao incluir na tabela de item'+
       sLineBreak+e.ClassName+sLineBreak+e.Message);
  end;
end;



function TfrmPrincipal.pesquisa(cNOME: string): Boolean;
begin
  if trim(cnome) = '' then
     begin
       Result := false;
     end
  else
     begin
       if qrProduto.Active then
          qrProduto.Close;

        qrProduto.sql.Clear;
        qrProduto.sql.add('select * from produto');
        qrProduto.sql.add('where descricao like :cDESCRICAO');
        qrProduto.ParamByName('cDESCRICAO').AsString:='%'+trim(cNOME)+'%' ;
        qrProduto.Open;
        if qrProduto.RecordCount = 1 then
           begin
             pnpDescricao.Caption:=qrProdutoDESCRICAO.Value;
             nQTDE.Value:=1;
             nUNIT.Value:=qrProdutoVENDA.Value;
             pnpPESQUISA.Visible:=false;
           end
        else if qrProduto.RecordCount > 1 then
           begin
             pnpPESQUISA.Visible:=true;
           end;

     end;
end;

function TfrmPrincipal.PesqProd(cTexto: string): boolean;
begin
  if qrProduto.Active then
     qrProduto.Close;
  qrProduto.sql.Clear;
  qrProduto.sql.add('select * from produto');
  qrProduto.sql.add('where barras in(:cBARRAS) or CODIGO in(:nCODIGO)');
  qrProduto.ParamByName('cBARRAS').AsString:=trim(cCODIGO.Text);
  qrProduto.ParamByName('nCODIGO').AsInteger := StrToIntDef(cCODIGO.Text,0);
  qrProduto.Open;
  if qrProduto.RecordCount > 0 then
     begin
       pnpDescricao.Caption:=qrProdutoDESCRICAO.Value;
       cCODIGO.Text:=inttostr(qrProdutoCODIGO.Value);
       result := true
     end
  else
     result := false;
end;

function TfrmPrincipal.EtiquetaBal: boolean;
var
  nPESO, nVALOR : real;
begin
  nPESO:=0;
  nVALOR:=0;
  if Length(trim(cCODIGO.Text)) = 13 then
     begin
       if Copy(cCODIGO.Text, 1,1) = '2' then
          begin
            // Etq Peso
            nPESO:=StrToFloat(copy(cCODIGO.Text,8,5))/1000;
            cCODIGO.Text:=copy(cCODIGO.Text,2,6);
          end
       else if Copy(cCODIGO.Text,1,2) = '31' then
          begin
            // etq valor
            nVALOR:=StrToFloat(copy(cCODIGO.Text,8,5))/100;
            cCODIGO.Text:=copy(cCODIGO.Text,3,5);
          end ;
       if (nVALOR <> 0) or (nPESO <> 0) then // se o peso ou valor for diferente de zero.. entao é nao trata etq como balanca
           begin
             if PesqProd(cCODIGO.Text) then
                begin
                  if nVALOR > 0  then
                     nPESO:=nVALOR/qrProdutoVENDA.Value;
                  nQTDE.Value:=nPESO;
                  nUNIT.Value:=qrProdutoVENDA.Value;
                  nSubTot.Value:=nPESO * qrProdutoVENDA.Value;
                  IncluiItem;
                  Result := true;
                end;
           end
       else
          Result := false;
     end
  else
     Result := false;

end;




end.

