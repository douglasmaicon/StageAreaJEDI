unit frmCredencial;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TFCredencial = class(TForm)
    Label1: TLabel;
    edtIP: TEdit;
    Label2: TLabel;
    edtUsuario: TEdit;
    edtPorta: TEdit;
    Label3: TLabel;
    edtSenha: TEdit;
    btnConectar: TBitBtn;
    btnCancelar: TBitBtn;
    procedure btnCancelarClick(Sender: TObject);
    procedure btnConectarClick(Sender: TObject);
    procedure edtSenhaKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FCredencial: TFCredencial;

implementation

uses frmPrincipal;

{$R *.dfm}

procedure TFCredencial.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TFCredencial.btnConectarClick(Sender: TObject);
begin
  { TODO -oJonathan -c : Implementar conexão com JEDI 25/03/2016 01:15:02 }
  TFStageAreaJEDI.abrirStageArea(Sender);
  Self.Visible := False;
end;

procedure TFCredencial.edtSenhaKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
    btnConectar.Click;
end;

end.
