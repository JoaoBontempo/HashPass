// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get closeAppConfirmationTitle => 'Fechar o aplicativo?';

  @override
  String get closeAppConfirmationMessage =>
      'Tem certeza que deseja sair do HashPass?';

  @override
  String get updatedDataMessage => 'Informações atualizadas com sucesso!';

  @override
  String get newPasswordShowCase => 'Toque aqui para cadastrar uma nova senha!';

  @override
  String get passwordFilterShowCase =>
      'Utilize este campo para filtrar suas senhas cadastradas por título ou por credencial';

  @override
  String get passwordFilterPlaceholder => 'Pesquisar título, credencial...';

  @override
  String get notFoundPassword => 'Nenhuma senha encontrada!';

  @override
  String get noRegisteredPasswords => 'Nenhuma senha foi cadastrada!';

  @override
  String get registerNewPassword => 'Cadastrar nova senha';

  @override
  String get simpleCardShowcase =>
      'Toque uma vez para visualizar a senha. Toque e segure por alguns segundos para copiar a senha.';

  @override
  String get deletePasswordShowCase => 'Toque aqui para excluir a senha';

  @override
  String get editPasswordShwocase =>
      'Toque aqui para editar as informações da senha';

  @override
  String get defaultCardShowcase =>
      'Você pode editar algumas informações no próprio card, como a credencial e a senha. Para senhas criptografadas, é possível alterar o algoritmo e o tipo de criptografia.';

  @override
  String get credential => 'Credencial';

  @override
  String get emptyCredential => 'A credencial não pode estar vazia!';

  @override
  String get basePassword => 'Senha base';

  @override
  String get password => 'Senha';

  @override
  String get emptyPassword => 'A senha não pode estar vazia!';

  @override
  String get shortPassword => 'A senha é curta demais!';

  @override
  String get copyPassword => 'Copiar senha';

  @override
  String get hashFunction => 'Função Hash';

  @override
  String get advanced => 'Avançado';

  @override
  String get showCardPassword => 'Visualizar senha';

  @override
  String get savePasswordShowcase =>
      'Toque aqui para salvar as informações da sua senha';

  @override
  String get changePasswordMenu => 'Mudar senha geral';

  @override
  String get exportImportDataMenu => 'Exportar/Importar';

  @override
  String get passworkLeakMenu => 'Vazamento de senha';

  @override
  String get passworkLeakMenuNoAuthorized =>
      'Não é possível utilizar a verificação de vazamento sem conexão com a internet.';

  @override
  String get settings => 'Configurações';

  @override
  String get privacyPolicy => 'Política de privacidade';

  @override
  String get about => 'Sobre';

  @override
  String get authNeeded => 'Autenticação necessária';

  @override
  String get verifyIdentity => 'Verificação de identidade';

  @override
  String get setLastAppKey => 'Informe sua senha antiga:';

  @override
  String get appKey => 'Senha do aplicativo:';

  @override
  String get keyAttempts => 'Chave inválida! Tentativas restantes:';

  @override
  String get errorOcurred => 'Ocorreu um erro: ';

  @override
  String get unlockNeeded =>
      'O desbloqueio é necessário para recuperar a senha do aplicativo';

  @override
  String get validate => 'Validar';

  @override
  String get seconds => 'Segundos';

  @override
  String get enterApp => 'Entrar no app';

  @override
  String get showPassword => 'Mostrar senha';

  @override
  String get hidePassword => 'Ocultar senha';

  @override
  String get useCredentialTooltip =>
      'Marque esta caixa caso deseje salvar a credencial relacionada a esta senha. A credencial pode ser seu nome de usuário, e-mail, CPF, ou qualquer outra informação que deve ser utilizada junto com a senha que deseja guardar';

  @override
  String get saveCredential => 'Salvar credencial';

  @override
  String get useHashTooltip =>
      'Ao marcar esta caixa, sua senha real será a combinação entre uma senha base e um algoritmo hash.';

  @override
  String get useHash => 'Usar Hash';

  @override
  String get algorithm => 'Algoritmo';

  @override
  String get cipherMode => 'Modo de criptografia';

  @override
  String get normalCipher => 'Normal';

  @override
  String get normalCipherTooltip =>
      'Sua senha final será a senha base com o algoritmo hash aplicado.';

  @override
  String get advancedCipherTooltip =>
      'Além do algoritmo hash, sua senha real terá uma criptografia simétrica adicional.';

  @override
  String get save => 'Salvar';

  @override
  String get registerPassword => 'Cadastrar senha';

  @override
  String get confirm => 'Confirmar';

  @override
  String get confirmPasswordSave =>
      'Tem certeza que deseja cancelar a edição da senha?';

  @override
  String get confirmNewPasswordSave =>
      'Tem certeza que deseja cancelar o cadastro da senha?';

  @override
  String get newPassword => 'Nova senha';

  @override
  String get editPassword => 'Alterar senha';

  @override
  String get requiredTitle => 'O título é obrigatório';

  @override
  String get title => 'Título';

  @override
  String get requiredPassword => 'A senha é obrigatória!';

  @override
  String get passwordMinimumSizeMessage =>
      'A senha deve ter no mínimo 4 caracteres';

  @override
  String get register => 'Cadastrar';

  @override
  String get language => 'Liguagem';

  @override
  String get biometricConfigDescription =>
      'Configura a forma de validação da senha geral do app para biometria ou texto.';

  @override
  String get biometricConfigTitle => 'Validação biométrica';

  @override
  String get theme => 'Tema';

  @override
  String get timerConfigDescription =>
      'Ativar / desativar o temporizador de senha. O temporizador serve para limitar a quantidade de tempo que uma senha ficará disponível para visualização.';

  @override
  String get timerConfigTitle => 'Temporizador de senha';

  @override
  String get timerDurationConfigTitle => 'Duração do temporizador';

  @override
  String get timerDurationConfigDescription =>
      'Determina, em segundos, a duração do temporizador de senha.';

  @override
  String get passworkLeakConfigDescription =>
      'Configurações relacionadas com a verificação das senhas informadas por você no aplicativo.';

  @override
  String get insertPasswordLeakVerificationConfig =>
      'Ativa a verificação em real-time ao cadastrar uma senha. Somente será possível cadastrar uma senha verificada.';

  @override
  String get updatePasswordLeakVerificationConfig =>
      'Ativa a verificação em real-time ao atualizar uma senha já cadastrada. Não será possível salvar uma senha não verificada.';

  @override
  String get helpConfigDescription =>
      'Habilita ou desabilita ícones de ajuda (?) para informações e explicações de ajuda a respeito de como o aplicativo funciona.';

  @override
  String get helpConfigTitle => 'Habilitar ajuda';

  @override
  String get cardStyleConfigTitle => 'Estilo de interface';

  @override
  String get cardStyleConfigDescription =>
      'Determina o estilo dos cards aplicativo ao listar suas senhas. O estilo simples será um card mais minimalista e o padrão será um card mais completo.';

  @override
  String get simple => 'Simples';

  @override
  String get default_ => 'Padrão';

  @override
  String get registerVerifyTitle => 'Verificar ao cadastrar';

  @override
  String get updateVerificationTitle => 'Verificar ao atualizar';

  @override
  String get passwordShouldNotHaveSpacesMessage =>
      'A senha não pode conter espaços!';

  @override
  String get confirmPassword => 'Confirme sua senha';

  @override
  String get notEqualPasswords => 'As senhas informadas não são iguais';

  @override
  String get tryAgain => 'Por favor, tente novamente.';

  @override
  String get changeGeneralKeySuccess =>
      'Senha geral do HashPass alterada com sucesso!';

  @override
  String get dataExportSuccessMessage =>
      'Seus dados foram exportados com sucesso! Você deverá usar a chave abaixo para importar seus dados.';

  @override
  String get dataExportSuccessTitle => 'Dados exportados com sucesso!';

  @override
  String get dataImportSuccessTitle => 'Dados importados com sucesso!';

  @override
  String get copyToken => 'Copiar token';

  @override
  String get dataExport => 'Exportação de dados';

  @override
  String get dataImport => 'Importação de dados';

  @override
  String get dataExportExplanation =>
      'Será gerado um arquivo contendo suas senhas, criptografado com uma chave gerada aleatoriamente. Você poderá exportar este arquivo para o lugar de sua preferência e copiar a chave aleatória que foi gerada. A chave será necessária para decifrar o conteúdo do arquivo criptografado do arquivo na importação de dados.';

  @override
  String get dataImportExplanation =>
      'Insira a chave criptográfica que foi gerada ao exportar os dados e pressione o botão \'Importar dados\'. Selecione o arquivo que contém seus dados para que seja possível a importação. Certifique-se de que você está usando a chave e o arquivo corretos e que sua chave geral do HashPass é a mesma de quando você exportou os dados. Será necessário permitir o acesso aos arquivos do dispositivo.';

  @override
  String get doNotShareToken =>
      'Não compartihe seu token e não envie o arquivo para ninguém!';

  @override
  String get export => 'Exportar';

  @override
  String get import => 'Importar';

  @override
  String get insertExportToken => 'Insira seu token';

  @override
  String get emptyFieldMessage => 'Este campo não pode estar vazio';

  @override
  String get chooseImportFile => 'Selecione o arquivo para importação';

  @override
  String get accessDenied => 'Acesso negado';

  @override
  String get fileAccessRequired =>
      'Para importar seus dados, é necessário permitir o acesso aos arquivos do dispositivo.';

  @override
  String get unknowErrorToOpenFile => 'Erro desconhecido ao abrir o arquivo';

  @override
  String get unknowErrorToOpenFileManager =>
      'Ocorreu um erro inesperado ao abrir o gerenciador de arquivos.';

  @override
  String get dataImportCanceled =>
      'Importação cancelada. Nenhum arquivo foi selecionado';

  @override
  String get dataImportErrorMessage =>
      'Um erro inesperado ocorreu ao importar seus dados. Por favor, tente novamente \n\n* Verifique se a chave inserida está correta\n* Verifique se o arquivo selecionado é o correto para esta chave\n* Verifique se sua chave geral do app é a mesma de quando você exportou os arquivos';

  @override
  String get insertPasswordToBeVerified =>
      'Informe uma senha para que ela seja verificada em bases de dados de senhas que já foram vazadas na internet.';

  @override
  String get typePassword => 'Digite sua senha';

  @override
  String get verifyPassword => 'Verificar senha';

  @override
  String get version => 'Versão';

  @override
  String get aboutHashPass =>
      'HashPass é um software que tem o objetivo de ser uma solução simples para armazenar as senhas dos seus apps e serviços de forma segura, utilizando criptografia.';

  @override
  String get developedBy => 'Desenvolvido por';

  @override
  String get generalKeyRegistered => 'Chave cadastrada com sucesso!';

  @override
  String get setFirstConfigMessage =>
      'O HashPass possui algumas configurações para que sua experiência com o app seja personalizada, como temporizador de visualização de senha, verificação de vazamento de senha, ícones de ajuda, dentre outras opções.\n\nDeseja utilizar as configurações padrão e alterá-las posteriormente ou deseja configurar o app agora?';

  @override
  String get useDefaultConfig => 'Usar configurações padrão';

  @override
  String get configTheApp => 'Quero configurar o app';

  @override
  String get start => 'Começar';

  @override
  String get appReady => 'Tudo certo!';

  @override
  String get initialSettings => 'Configurações iniciais';

  @override
  String get next => 'Continuar';

  @override
  String get welcome => 'Bem vindo ao HashPass!';

  @override
  String get shouldAgreePolicy =>
      'Para continuar, é necessário concordar com os termos da política de privacidade do aplicativo.';

  @override
  String get registerGeneralKeyError =>
      'Um erro desconhecido ocorreu ao cadastrar sua senha geral. Por favor, tente novamente.';

  @override
  String get agreeWithTerms => 'Concordo com os termos da ';

  @override
  String get insertGeneralKey => 'Informe uma senha geral';

  @override
  String get welcomeParagraphOne =>
      'HashPass é um aplicativo criado para guardar suas senhas de forma segura. Para isso, será necessário criar uma senha geral para o app, pois suas senhas serão armazenadas com criptografia simétrica, sendo assim, uma única senha é responsável por recuperar todas suas senhas, ou seja, ela é a única coisa que você deverá lembrar.';

  @override
  String get welcomeParagraphTwo =>
      'Não será possível recuperar esta senha, portanto, guarde sua senha geral e não esqueça ou compartilhe esta senha de forma alguma.';

  @override
  String get welcomeParagraphThree =>
      'Você poderá acessá-la com sua biometria posteriormente, caso seu dispositivo suporte esse recurso.';

  @override
  String get darkTheme => 'Escuro';

  @override
  String get lightTheme => 'Padrão';

  @override
  String get autoTheme => 'Automático (Sistema)';

  @override
  String get decipherFailure => 'Erro ao decifrar a senha';

  @override
  String get passwordSuccessRegister => 'Senha cadastrada com sucesso!';

  @override
  String get passwordSuccessUpdate => 'Senha atualizada com sucesso!';

  @override
  String get passwordCopied => 'Senha copiada!';

  @override
  String get passwordRecoverError => 'Ocorreu um erro ao recuperar sua senha';

  @override
  String get confirmDelete => 'Confirmar exclusão';

  @override
  String get confirmDeleteMessage =>
      'Você tem certeza que deseja excluir esta senha? Esta ação não poderá ser desfeita.';

  @override
  String get deleteSuccess => 'Senha excluída com sucesso!';

  @override
  String get deleteError =>
      'Ocorreu um erro ao excluir a senha. Por favor, tente novamente';

  @override
  String get leakedPassword => 'Senha vazada';

  @override
  String get notVerifiedPassword => 'Senha não verificada';

  @override
  String get confirmSaveLeakedPassword =>
      'A senha que você está tentando salvar já foi vazada! Você deseja salvá-la mesmo assim?';

  @override
  String get confirmSaveNotVerifiedPassword =>
      'Não foi possível verificar sua senha, pois um erro ocorreu ou não há conexão com a internet. Deseja salvar sua senha mesmo assim?';

  @override
  String get confirmSavePassword =>
      'Tem certeza que deseja atualizar os dados desta senha?';

  @override
  String get yes => 'Sim';

  @override
  String get no => 'Não';

  @override
  String get updateAndInsertLeakConfigDescription =>
      'Ativar / desativar a verificação de vazamento de senha ao cadastrar e ao atualizar uma senha.';

  @override
  String get couldNotVerifyPassword =>
      'Não foi possível verificar sua senha. Verifique sua conexão de internet ou tente novamente.';

  @override
  String get passwordLeakedOnce => 'Esta senha foi vazada pelo menos uma vez!';

  @override
  String get passwordMaybeNotLeaked =>
      'Sua senha tem grandes chances de não ter sido vazada!';

  @override
  String get passwordLeakedMoreThanOnce => 'Esta senha foi vazada pelo menos';

  @override
  String get times => 'vezes';

  @override
  String get pathNotes => 'Notas de atualização';

  @override
  String get pathNotesIntroduction => 'Seguem abaixo as notas da atualização';

  @override
  String get update1_3_0_title => 'A versão 1.3.0 do HashPass chegou!';

  @override
  String get update1_3_0_description =>
      'Esta é a primeira atualização do aplicativo desde que o desenvolvi e publiquei enquanto estava na faculdade. Algumas novas ideias e surgiram e esta é apenas uma pequena atualização de preparação para algo ainda melhor que está por vir!\n\nMuito orbigado por utilizar o HashPass!';

  @override
  String get update1_3_0_note1 =>
      'Nova função: Gerador de senha (presente no menu lateral). Gere uma senha segura e salve-a no HashPass;';

  @override
  String get update1_3_0_note2 =>
      'O HashPass agora está internacionalizado. Você pode alterar a linguagem do aplicativo para Português (BR) ou Inglês (US).';

  @override
  String get passwordGeneratorMenu => 'Gerador de senha';

  @override
  String get passwordSize => 'Tamanho da senha';

  @override
  String get lowercases => 'Minúsculas';

  @override
  String get uppercases => 'Maiúsculas';

  @override
  String get numbers => 'Números';

  @override
  String get symbols => 'Símbolos';

  @override
  String get charBlackList => 'Lista negra de caracteres';

  @override
  String get blackListDescription =>
      'Os caracteres contidos neste campo não farão parte da senha gerada';

  @override
  String get generatePassword => 'Gerar senha';

  @override
  String get passwordDetails => 'Detalhes da senha';

  @override
  String get generatedPassword => 'Senha gerada';

  @override
  String get invalidParameters => 'Parametros inválidos';

  @override
  String get everyDigitOnBlacklist =>
      'Não é possível gerar uma senha contendo somente números se todos os algarismos ([0-9]) estiverem na lista negra.';

  @override
  String get useDesktopTitle => 'Módulo desktop';

  @override
  String get useDesktopDescription =>
      'Ativar ou desativar a integração com a versão desktop do HashPass';

  @override
  String get stablishingConnection => 'Estabelecendo conexão desktop...';

  @override
  String get desktopConnection => 'Conexão Desktop';

  @override
  String get cancel => 'Cancelar';

  @override
  String get simpleTryAgain => 'Tentar novamente';

  @override
  String get connectionStablished => 'Conexão estabelecida com sucesso!';

  @override
  String get connectionFailure => 'Não foi possível estabelecer a conexão';

  @override
  String get restart => 'Reiniciar';

  @override
  String get update2_0_0_title =>
      'A versão 2.0.0 do HashPass chegou, no modelo open-source!';

  @override
  String get update2_0_0_description =>
      'O aplicativo agora está operando em modelo open-source. Além disso, há uma ferramenta disponível: O Módulo Desktop!';

  @override
  String get update2_0_0_note1 =>
      'Com o módulo desktop, é possível copiar as senhas através deste dispositivo diretamente para um computador.';

  @override
  String get update2_0_0_note2 =>
      'Em breve será possível importar as senhas salvas em navegadores.';
}
