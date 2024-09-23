# Otimização de Consumo de Energia no Homelab

Para otimizar o consumo de energia no seu homelab e economizar alguns watts, você pode ajustar configurações específicas utilizando a ferramenta **PowerTOP**. Esse ajuste ajuda a reduzir o consumo de energia de componentes e serviços que não estão sendo usados de forma ativa, especialmente em servidores e estações de trabalho.

**PowerTOP** é uma ferramenta que analisa o uso de energia do sistema e sugere otimizações. Após a instalação, você pode navegar pelo PowerTOP usando as teclas **TAB** para avançar entre as opções e **Shift+TAB** para voltar. Isso permite que você veja o status de energia e identifique onde estão as maiores demandas de consumo.

Após a instalação, basta rodar o comando `powertop` para visualizar o status de energia e ver sugestões de otimização. Para automatizar essas otimizações, você pode usar o comando `powertop --auto-tune`, que aplica todas as sugestões recomendadas automaticamente.

**É importante observar que o passo a passo abaixo **não faz parte** do script de instalação deste tutorial, e é uma configuração extra para ajustar a energia de forma contínua no seu homelab.**

### Passo a passo:

1.  Instale o PowerTOP:
    
    ```console
    apt-get install powertop
    ```
    
2.  Crie um arquivo de serviço para o PowerTOP:
    
    ```console
    nano /etc/systemd/system/powertop.service
    ```
    
3.  No arquivo, insira o seguinte conteúdo:
    
    ```scss
    [Unit]
    Description=PowerTOP auto-tuning
    
    [Service]
    Type=oneshot
    ExecStart=/usr/sbin/powertop --auto-tune
    
    [Install]
    WantedBy=multi-user.target
    ```
    
4.  Salve o arquivo e habilite o serviço:
    
    ```console
    systemctl enable powertop.service
    ```
    
5.  Verifique se o serviço foi habilitado com sucesso. A resposta deve ser:
    
    ```console
    Created symlink /etc/systemd/system/multi-user.target.wants/powertop.service → /etc/systemd/system/powertop.service.
    ```
    

Com isso, o PowerTOP será automaticamente executado durante a inicialização, aplicando as otimizações de energia recomendadas e ajudando a economizar alguns watts de forma contínua.
