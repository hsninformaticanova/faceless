# Site para publicar o app OAuth

Três páginas estáticas que atendem aos requisitos do Google para publicar um
app **Externo** com escopo sensível (`youtube.upload`): página inicial,
política de privacidade e termos de serviço, num domínio verificável.

```
index.html       página inicial do app
privacidade.html política de privacidade (exigida)
termos.html      termos de serviço
style.css        estilo único, claro e escuro
```

Não há dependência externa: nenhum script, nenhuma fonte remota, nenhum
rastreador. Isso importa porque uma política de privacidade que carrega
rastreador de terceiros se contradiz.

## Publicar no GitHub Pages

```bash
# 1. Crie um repositório público chamado facelessos
# 2. Suba só o conteúdo desta pasta
cd site
git init && git add . && git commit -m "site do app OAuth"
git branch -M main
git remote add origin git@github.com:SEU-USUARIO/facelessos.git
git push -u origin main
```

No repositório: **Settings → Pages → Source: main, pasta / (root)**.

Em poucos minutos o site responde em
`https://SEU-USUARIO.github.io/facelessos/`.

## Verificar o domínio

1. Abra o [Google Search Console](https://search.google.com/search-console)
2. Adicione a propriedade **Prefixo do URL**: `https://SEU-USUARIO.github.io/`
3. Verifique pelo método de **tag HTML** — copie a meta tag e cole no
   `<head>` do `index.html`, republique e confirme

O domínio precisa estar verificado **na mesma conta Google** do projeto no
Cloud Console.

## Preencher no Google Cloud

Em **APIs e serviços → Tela de permissão OAuth → Branding**:

| Campo | Valor |
|---|---|
| Página inicial do aplicativo | `https://SEU-USUARIO.github.io/PROJETO/` |
| Link da Política de Privacidade | `https://SEU-USUARIO.github.io/PROJETO/privacidade.html` |
| Link dos Termos de Serviço | `https://SEU-USUARIO.github.io/PROJETO/termos.html` |
| Domínios autorizados | `SEU-USUARIO.github.io` |

**Atenção ao domínio autorizado:** use o host completo
(`SEU-USUARIO.github.io`), não `github.io`. O Google recusa `github.io` com a
mensagem "precisa ser um domínio privado de nível superior", porque ele consta
na Public Suffix List — qualquer pessoa pode criar um subdomínio ali, então
autorizá-lo inteiro seria autorizar o GitHub Pages do mundo todo.

Salve e vá em **Público-alvo → PUBLICAR APP**.

### Se reclamar que o domínio não está verificado

A propriedade verificada no Search Console precisa cobrir o host, não apenas
o subdiretório do projeto. Se `https://SEU-USUARIO.github.io/PROJETO/` não for
aceito, verifique também a raiz `https://SEU-USUARIO.github.io/` — para isso é
preciso um repositório chamado exatamente `SEU-USUARIO.github.io`, com um
`index.html` carregando a mesma meta tag de verificação.

Não suba logotipo: o próprio console avisa que isso força o envio para
verificação.

## O que esperar depois

O app fica "Em produção" **sem verificação**, o que é suficiente para uso
próprio:

- O refresh token **deixa de expirar em 7 dias** — que é o motivo de tudo isto
- Ao autorizar aparece o aviso "app não verificado": siga em
  **Avançado → Acessar FacelessOS**
- Limite de 100 contas autorizadas, irrelevante para uso pessoal

A verificação formal do Google só é necessária para distribuir o app a
terceiros ou remover a tela de aviso.

## Antes de publicar

O texto das páginas descreve o comportamento real do aplicativo. Se o projeto
mudar — novos escopos, coleta de alguma métrica, uso em mais de um canal —
atualize as páginas antes, não depois: uma política de privacidade que não
corresponde ao software é pior do que nenhuma.
