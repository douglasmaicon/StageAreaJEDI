unit frmPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, Menus, ExtCtrls, Buttons, XPMan, ComCtrls,
  ImgList;

type
  TBandeira = (BanVERMELHA, BanVERDE);
  TFStageAreaJEDI = class(TForm)
    pnlTopo: TPanel;
    pnlLateral: TPanel;
    Splitter1: TSplitter;
    pnlGeral: TPanel;
    pnlLateralButon: TPanel;
    pnlLateralTopo: TPanel;
    mmDescricaoGeral: TMemo;
    lstUnstage: TListBox;
    lstStage: TListBox;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    pgSolicitacoes: TPageControl;
    pnlGeralSoicitacoes: TPanel;
    Label1: TLabel;
    edtSolicitacao: TEdit;
    StatusBar1: TStatusBar;
    pnlAcoesUnstage: TPanel;
    SpeedButton1: TSpeedButton;
    imgBandeiras: TImageList;
    ppMenuUnstage: TPopupMenu;
    AdicionarNaStage1: TMenuItem;
    Ocultar1: TMenuItem;
    imgPopUpUnstage: TImageList;
    sbAdicionarNaStageArea: TSpeedButton;
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtSolicitacaoKeyPress(Sender: TObject; var Key: Char);
    procedure DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DragDropCopia(Sender, Source: TObject; X, Y: Integer);
    procedure DragDropMove(Sender, Source: TObject; X, Y: Integer);
    procedure lstUnstageExit(Sender: TObject);
    procedure lstUnstageEnter(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lstUnstageDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lstUnstageMeasureItem(Control: TWinControl; Index: Integer;
      var Height: Integer);
    procedure AdicionarNaStage1Click(Sender: TObject);
    procedure sbAdicionarNaStageAreaClick(Sender: TObject);

  private
    FIcoVermelho : TImage;
    FIcoVerde    : TImage;

    procedure setIconeVerde();
    procedure setIconeVermelho();

    function getIconeVerde():TImage;
    function getIconeVermelho():TImage;

    procedure adicionarNovaAba(panelControl:TPageControl; codSolicitacao:string; textoDescEspecifica:string='');
    procedure adicionarUnitUnstage(texto: string; bandeira: TBandeira);
    procedure adicionarNaStageArea;


    { Private declarations }
  public
    { Public declarations }
    class procedure abrirStageArea(Sender:TObject);
  end;


implementation

{$R *.dfm}

var
  FStageAreaJEDI: TFStageAreaJEDI;

class procedure TFStageAreaJEDI.abrirStageArea(Sender: TObject);
begin
  if FStageAreaJEDI = nil then
    FStageAreaJEDI := TFStageAreaJEDI.Create(Application);
  FStageAreaJEDI.Show;
end;

procedure TFStageAreaJEDI.SpeedButton2Click(Sender: TObject);
begin
  ShowMessage('Implementar teste de conexão!');
end;

procedure TFStageAreaJEDI.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Application.Terminate();
end;


procedure TFStageAreaJEDI.adicionarNovaAba(panelControl:TPageControl; codSolicitacao:string; textoDescEspecifica:string='');
var
  newTab: TTabSheet;
  descricaoEspecifica   : TMemo;
  lstUnitsSolicitacoes  : TListBox;
begin
  if Length(codSolicitacao) <> 4 then
    Exit;

  newTab := TTabSheet.Create(panelControl);
  newTab.PageControl  := panelControl;
  newTab.Caption      := codSolicitacao;

  descricaoEspecifica := TMemo.Create(panelControl);
  with descricaoEspecifica do
    begin
      Name    := 'mm' + IntToStr(newTab.TabIndex);
      Text    := textoDescEspecifica;
      Parent  := newTab;
      Height  := 105;
      Align   := alTop;
    end;

  lstUnitsSolicitacoes := TListBox.Create(panelControl);
  with lstUnitsSolicitacoes do
    begin
      Name        := 'lst' + IntToStr(newTab.TabIndex);
      Parent      := newTab;
      Align       := alClient;
      OnDragDrop  := FStageAreaJEDI.DragDropCopia;
      OnDragOver  := FStageAreaJEDI.DragOver;
      OnMouseDown := FStageAreaJEDI.MouseDown;
    end;
    
  panelControl.ActivePage := newTab;
end;


procedure TFStageAreaJEDI.edtSolicitacaoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    begin
      TEdit(Sender).Text := FormatFloat('0000', StrToIntDef(TEdit(Sender).Text, 0));
      adicionarNovaAba(pgSolicitacoes, edtSolicitacao.Text, mmDescricaoGeral.Text);
      TEdit(Sender).Clear;
    end;
end;


//Move registro
procedure TFStageAreaJEDI.DragDropMove(Sender, Source: TObject; X,
  Y: Integer);
var
  i : Integer;
  found : Boolean;
begin
  with (Source AS TListBox) do
    begin
      for i := 0 to Items.Count - 1 do
        if Selected[i] then
          (Sender AS TListBox).Items.Add(Items[i]);

      for i := Items.Count - 1 downto 0 do
        if Selected[i] then
          Items.Delete(i);
    end;
end;

//Copia Registro
procedure TFStageAreaJEDI.DragDropCopia(Sender, Source: TObject; X,
  Y: Integer);
var
  i, n : Integer;
  found : Boolean;
begin
  with Source as TListBox do
    begin
      for i := 0 to Items.Count - 1 do
        if Selected[i] then
          begin
            found := False;
            for n := 0 to (Sender AS TListBox).Items.Count - 1 do
              if (Sender AS TListBox).Items[n] = Items[i] then
                found := True;

              if not found then
                (Sender AS TListBox).Items.Add(Items[i]);
          end;
    end;
end;



procedure TFStageAreaJEDI.DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := (Source is TListBox);
end;


procedure TFStageAreaJEDI.MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if ssShift in Shift then
    TListBox(Sender).BeginDrag(True);
end;

procedure TFStageAreaJEDI.lstUnstageExit(Sender: TObject);
begin
  pnlAcoesUnstage.Enabled := False;
end;

procedure TFStageAreaJEDI.lstUnstageEnter(Sender: TObject);
begin
  pnlAcoesUnstage.Enabled := True;
end;

procedure TFStageAreaJEDI.FormCreate(Sender: TObject);
begin
  lstUnstage.Style := lbOwnerDrawVariable;
  setIconeVerde();
  setIconeVermelho();



  adicionarUnitUnstage('UTributo - D:\caminhoCompleto', BanVERMELHA);
  adicionarUnitUnstage('UFerramentas - D:\caminhoCompleto', BanVERDE);
  adicionarUnitUnstage('UFerramentas - D:\caminhoCompleto', BanVERDE);
  adicionarUnitUnstage('UFerramentas - D:\caminhoCompleto', BanVERDE);
  adicionarUnitUnstage('UTributo - D:\caminhoCompleto', BanVERMELHA);
  adicionarUnitUnstage('UFerramentas - D:\caminhoCompleto', BanVERDE);
  adicionarUnitUnstage('UFerramentas - D:\caminhoCompleto', BanVERDE);
  adicionarUnitUnstage('UTributo - D:\caminhoCompleto', BanVERMELHA);
  
end;

procedure escreverTextoItem(Cnv: TCanvas; Rect: TRect; S: string);
var
  y : Integer;
begin
  y := (Rect.Bottom + Rect.Top  - Cnv.TextHeight(S)) div 2;
  Cnv.TextOut(20, Y, S);
end;

procedure TFStageAreaJEDI.lstUnstageDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  Bitmap: TBitmap;
begin
  with TListBox(Control) do
    begin
      Canvas.FillRect(Rect);
      if Items.Objects[Index] <> nil then
        begin
          Bitmap := Items.Objects[Index] as TBitmap;
          Canvas.BrushCopy(Bounds(Rect.Left + 1, Rect.Top + 1,
                            Bitmap.Width, Bitmap.Height), Bitmap, Bounds(0, 0, Bitmap.Width,
                            Bitmap.Height), Bitmap.Canvas.Pixels[0, Bitmap.Height - 1]);
        end;
      Rect.Left   := Rect.Left + Bitmap.Width  + 3;
      Rect.Bottom := Rect.Top  + Bitmap.Height + 3;
      escreverTextoItem(Canvas, Rect, Items.Strings[Index]);
    end;
end;

procedure TFStageAreaJEDI.lstUnstageMeasureItem(Control: TWinControl;
  Index: Integer; var Height: Integer);
begin
  if Index = 0 then
    Height := getIconeVerde.Height + 4;
end;


procedure TFStageAreaJEDI.adicionarUnitUnstage(texto:string; bandeira:TBandeira);
begin

  case bandeira of
    BanVERMELHA : begin
                    if lstUnstage.Items.Count = 0 then //Tratamento para primeiro registro
                      begin
                        lstUnstage.Items.AddObject(texto, getIconeVermelho.Picture.Bitmap);
                        lstUnstage.Items.AddObject(texto, getIconeVermelho.Picture.Bitmap);
                        lstUnstage.Items.Delete(0);
                      end
                    else
                      lstUnstage.Items.AddObject(texto, getIconeVermelho.Picture.Bitmap);
                  end;
    BanVERDE    : begin
                    if lstUnstage.Items.Count = 0 then //Tratamento para primeiro registro
                      begin
                        lstUnstage.Items.AddObject(texto, getIconeVerde.Picture.Bitmap);
                        lstUnstage.Items.AddObject(texto, getIconeVerde.Picture.Bitmap);
                        lstUnstage.Items.Delete(0);
                      end
                    else
                      lstUnstage.Items.AddObject(texto, getIconeVerde.Picture.Bitmap);
                  end;
  end;

end;

function TFStageAreaJEDI.getIconeVerde: TImage;
begin
  Result := FIcoVerde;
end;

function TFStageAreaJEDI.getIconeVermelho: TImage;
begin
  Result := FIcoVermelho
end;

procedure TFStageAreaJEDI.setIconeVerde;
begin
  if FIcoVerde = nil then
    FIcoVerde := TImage.Create(Application);
  imgBandeiras.GetBitmap(0, FIcoVerde.Picture.Bitmap);
end;

procedure TFStageAreaJEDI.setIconeVermelho;
begin
  if FIcoVermelho = nil then
    FIcoVermelho := TImage.Create(Application);
  imgBandeiras.GetBitmap(1, FIcoVermelho.Picture.Bitmap);
end;

procedure TFStageAreaJEDI.adicionarNaStageArea();
begin
  lstStage.Items.AddObject(lstUnstage.Items.Strings[lstUnstage.itemIndex], lstUnstage.Items.Objects[lstUnstage.itemIndex]);
end;

procedure TFStageAreaJEDI.AdicionarNaStage1Click(Sender: TObject);
begin
  adicionarNaStageArea();
end;

procedure TFStageAreaJEDI.sbAdicionarNaStageAreaClick(Sender: TObject);
begin
  adicionarNaStageArea();
end;

end.
