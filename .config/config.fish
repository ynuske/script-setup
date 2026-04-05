# --- Configuração de Logo Aleatório para o Fastfetch (Caminho Específico) ---
set fetch_dir "/home/ynuske/Documentos/fetch_logo"

# Verifica se o diretório existe
if test -d $fetch_dir
    # Obtém a lista de arquivos
    set logos $fetch_dir/*
    
    # Verifica se existem arquivos na lista
    if count $logos > /dev/null
        # Escolhe um aleatório usando o 'random choice' nativo do Fish
        set random_logo (random choice $logos)
        
        # Executa o fastfetch
        # --logo-type kitty é ideal para o CachyOS
        fastfetch --logo $random_logo --logo-type kitty --logo-width 35 --logo-height 0
    else
        # Se a pasta estiver vazia, executa o padrão
        fastfetch
    end
else
    # Se o caminho não for encontrado, executa o padrão
    fastfetch
end


#end Fastfetch config
