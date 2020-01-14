#!/bin/bash
#=========================HEADER==========================================|
#AUTOR
# Jefferson 'Slackjeff' Rocha <root@slackjeff.com.br>
#
#POR QUE?
# As vezes não sobra tempo para empressar o que sinto para minha amada.
# Então decidi criar este programa para automatizar minha vida e dizer
# todos os dias o que penso e sinto.
#
# Tudo é automatico, frases randomicas, imagens, desafios do dia e também
# envio para servidor.
#=========================================================================|

#========== VARIAVEIS
DATA="$(date +%d/%m/%y)"
source mlove.lst  # Carregando lib de frases
source mlovefunny.lst # Carregando lib de piadas
source mlove.conf # Carregando confs
source mlovechalenges.lst # Carregando desafios

#############################################
# FUNÇÕES
#############################################

# Cabeçalho do Documento
_head(){
	local random
	local total_imagens="$(echo img/* | wc -w)"
	random="$(( (RANDOM % total_imagens) + 1))"
	local IMG="$(echo img/* | cut -d' ' -f$random)"

    cat <<EOF > index.html
<!DOCTYPE html>
<html lang="pt-br">
<head>
	<title>$PAGE_NAME</title>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="shortcut icon" type="image/png" href="img/icon.jpg"/>
    <link href="https://fonts.googleapis.com/css?family=Mansalva&display=swap" rel="stylesheet">
	<style>
		body{background-color: white; font-size: 1.6em; margin: 0 auto;font-family: 'Mansalva', cursive;}
        h1{text-shadow: 7px 2px pink;}
        h2{text-shadow: 5px 2px pink;}
		header{
			padding: 3%;
			text-align: center;
			background-color: lightblue;
		}
		footer{text-align: center;}
		hr{border: 4px dashed lightblue;}
		.logo{width: 40%; border-radius: 50%;}
        .days{color: #ed00c3;}
        .msg{background-color: pink; padding-right: 2%; padding-left: 2%; padding-top: 5%; padding-bottom: 4%;}
	</style>
</head>
<body>
	<header>
		<h1>Bom dia $NAME!</h1>
		<img class="logo" src="$IMG"><br>
        <h2>Hoje é o dia <b class="days"><u>$DAYS</u></b> de 365 dias de mensagens.</h2>
	</header>
EOF
}

# Rodapé do documento
_footer(){
    cat <<EOF >> index.html
<hr>
<footer>
<h2>Te amo... Tenha um bom dia!</h2>
</footer>
</body>
</html>
EOF
}

# Pegando frase da lista e Gerando frase
# para impressão
_GENERATE_MSG()
{
	# Pegando o total de frases existentes na biblioteca
	total_msg=${#msg[@]}
	# Pegando o total de frases existentes na biblioteca
	total_msg_funny=${#msg_funny[@]}

	# Gerando frase randomica.
	number=$(( $RANDOM % $total_msg ))

	# Qual será a frase de hoje?
	print_msg="${msg[$number]}"
	cat << EOF >> index.html
<div class="msg">
	<b>Oi amor, hoje é dia ($DATA) e a minha mensagem para você é:</b><br><br>
	$print_msg
EOF

	# Gerando frase randomica.
	number=$(( $RANDOM % $total_msg_funny ))

	# Qual será a frase de hoje?
	print_msg="${msg_funny[$number]}"
	cat << EOF >> index.html
	<p>
	<b>E a piada do dia para você dar um sorrisão é:</b><br><br>
	$print_msg
	</p>
EOF

	# Desafio, imprimir ou não? 25 então imprimimos
    challenge="$(( ( RANDOM % 100) + 1))"
    if [[ "$challenge" = '25' ]] || [[ "$challenge" = '28' ]] || [[ "$challenge" = '34' ]]; then
    	challenge_total=${#msg_challenges[@]}
    	# Gerando frase randomica.
		number=$(( $RANDOM % $challenge_total ))
		print_msg="${msg_challenges[$number]}"
		cat << EOF >> index.html
	<b>O desafio que caiu foi:</b><br><br>
	$print_msg
</div>
EOF
	else
		echo "</div>" >> index.html
    fi
}

#+++++++++++++++++++++++++++++++++++++++++++

############################################
# Iniciando processo de envio
############################################

_head   # cabeçalho
_GENERATE_MSG         # gerando mensagem para impressão
_footer # gerando rodapé
# Aumentando número do dia +1 de 369
TEMP_DAYS=$(( $DAYS + 1 ))
sed -i "s@DAYS=.*@DAYS="\"$TEMP_DAYS\""@" mlove.conf

# Enviando para servidor.
#rsync -avzh /home/slackjeff/tati/ slackjeff@slackjeff.com.br:public_html/tati/\
