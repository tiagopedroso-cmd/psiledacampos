# Configuração da agenda — Leda Campos

Esta integração é independente do projeto O Corpo Responde. Ela usa credenciais, chaves de criptografia, prefixos Redis e conta Google próprios: todas as variáveis começam com LEDA_ e as reservas são gravadas com o prefixo leda:.

## 1. Publicar este projeto separadamente

1. Crie um novo projeto na Vercel a partir desta pasta, sem ligar ao projeto do O Corpo Responde.
2. Defina a URL final do site na variável LEDA_BOOKING_ORIGIN.
3. Faça um deploy antes de seguir: a URL de retorno do OAuth precisa existir.

## 2. Criar credenciais Google exclusivas

1. No Google Cloud, crie um novo projeto para Leda Campos.
2. Ative a Google Calendar API.
3. Em Google Auth Platform, configure o app como External e adicione os escopos openid, email, Calendar Events e Calendar FreeBusy.
4. Crie um cliente OAuth do tipo Web application.
5. Adicione exatamente a URL https://SEU-DOMINIO/api/oauth?action=callback.
6. Copie o Client ID e o Client Secret para LEDA_GOOGLE_CLIENT_ID e LEDA_GOOGLE_CLIENT_SECRET.

## 3. Criar armazenamento exclusivo

Crie uma nova base Upstash Redis exclusivamente para este projeto. Na Vercel, adicione as variáveis listadas em .env.example:

- LEDA_BOOKING_ORIGIN: URL final HTTPS deste site.
- LEDA_BOOKING_OWNER_EMAIL: e-mail Google que contém a agenda da Leda.
- LEDA_GOOGLE_CLIENT_ID e LEDA_GOOGLE_CLIENT_SECRET: credenciais do projeto Google da Leda.
- LEDA_BOOKING_ADMIN_SECRET: código aleatório com 32 ou mais caracteres.
- LEDA_BOOKING_ENCRYPTION_KEY: chave aleatória de 32 bytes em base64.
- LEDA_UPSTASH_REDIS_REST_URL e LEDA_UPSTASH_REDIS_REST_TOKEN: credenciais da nova base.

Nunca inclua esses valores no HTML, no Git ou em mensagens. Use somente as variáveis de Production na Vercel.

## 4. Autorizar a agenda

1. Faça novo deploy depois de cadastrar as variáveis.
2. Abra https://SEU-DOMINIO/conectar-agenda.html.
3. Informe o código de LEDA_BOOKING_ADMIN_SECRET.
4. Entre exclusivamente na conta Google configurada em LEDA_BOOKING_OWNER_EMAIL e aceite as permissões.
5. A tela deve mostrar Agenda conectada com sucesso.

## 5. Validar antes de divulgar

1. Escolha um horário futuro e confirme que ele aparece livre.
2. Faça um agendamento de teste com e-mail controlado.
3. Confirme na agenda da Leda o evento privado, a duração de 50 minutos e o convidado.
4. Confirme no e-mail de teste o convite Google.
5. Cancele o teste manualmente na agenda.

## Proteções implementadas

- O navegador nunca recebe credenciais Google.
- A disponibilidade consulta a agenda real antes de mostrar horários.
- A confirmação cria o evento no Google antes de mostrar sucesso.
- O e-mail do cliente entra como convidado e recebe o convite pelo Google.
- Redis impede duas confirmações simultâneas no mesmo horário.
- O OAuth só aceita a conta definida para a Leda.
- Nenhuma chave, token, Redis, projeto OAuth ou calendário do O Corpo Responde é utilizado.
