# troca.página

Aplicativo acadêmico de troca, compra e venda de livros usados.
A interface usa modo escuro em preto, branco e tons de cinza.

## Executar

Abra a pasta do projeto em uma instalação do Flutter compatível com
Dart 3.12.2 ou superior e execute:

```bash
flutter pub get
flutter run
```

Para usar o navegador:

```bash
flutter run -d chrome
```

## Telas

1. Login
2. Cadastro de usuário
3. Recuperação de senha
4. Sobre
5. Perfil do usuário
6. Feed principal
7. Detalhes do livro
8. Anunciar livro
9. Estante virtual
10. Lista de desejos

Cada tela possui seu próprio arquivo em lib/view.

## Organização

- lib/core: rotas, dependências e tema.
- lib/controller: dados e notificações de estado.
- lib/model: estrutura do livro.
- lib/view: telas e widgets compartilhados.

O projeto usa Material Design, GetIt e ChangeNotifier. A seleção de fotos
usa o image_picker. O DevicePreview está ativado, como no projeto original,
para visualizar as telas na moldura de um celular e escolher outros aparelhos.

## Uso

- Login: preencha um e-mail válido e uma senha.
- Cadastro: preencha os campos e confirme a mesma senha.
- Feed: combine busca, gênero e conservação.
- Anúncio: escolha até seis fotos, descreva o exemplar e defina o preço
  ou as condições de troca.
- Estante: acompanhe seus anúncios e marque leituras nos detalhes.
- Desejos: procure um título ou salve-o pelo coração. Os livros
  encontrados no catálogo aparecem com um aviso na lista.
- Perfil: edite seu nome; o e-mail corresponde ao usado no login.

## Dados do projeto

Os livros iniciais e as avaliações são dados estáticos. Anúncios, desejos,
leituras, nome e propostas ficam em memória durante a execução.

Nesta etapa, o projeto implementa interfaces, navegação e estado local.
Não possui banco de dados, pagamento, autenticação remota, envio de e-mails
ou notificações do sistema. As propostas e a recuperação de senha são
registradas na interface, sem envio a outras pessoas.

## Verificação em uma instalação do Flutter

```bash
dart format lib
flutter analyze
```
