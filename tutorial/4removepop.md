# **Remover o Pop-up de Assinatura do Proxmox**

Quando você instala o Proxmox VE ****sem uma assinatura válida**, um pop-up recorrente aparece avisando que você não tem uma assinatura ativa.** Embora o sistema continue funcionando sem restrições, esse pop-up pode ser irritante para muitos usuários. Removê-lo não afeta a funcionalidade do Proxmox, mas melhora a experiência de uso. **Remover ou não depende de você e do suporte que você quer dar ao projeto.** 

---
### **Passo a Passo para Remover o Pop-up de Assinatura**

1.  **Abra o terminal do Proxmox**.

2.  **Verifique o arquivo responsável pelo pop-up**:
    
    -   O arquivo que contém o código do pop-up está localizado em `/usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js`.
    
    Para verificar se o pop-up ainda está presente, use o seguinte comando:<p></p>
    
    ```console
    grep "Ext.Msg.show({\\s+title: gettext('No valid sub" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
    ```
	Este comando busca o trecho de código que cria o pop-up de aviso. Se o código for encontrado, significa que o pop-up está ativo.<p></p>
3.  **Remover o Pop-up de Assinatura**:
    
    -   Para remover o pop-up, aplique o comando `sed`, que altera o arquivo JavaScript e substitui o código que exibe o pop-up por um código vazio:<p></p>
    
    ```console
    sed -Ezi.bak "s/(Ext.Msg.show\\(\\{\\s+title: gettext\\('No valid sub)/void\\(\\{ \\/\\/\\1/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
    ```
	Este comando cria uma cópia de backup do arquivo (`proxmoxlib.js.bak`) e remove a função responsável por exibir o aviso de assinatura.<p></p>
	
4.  **Reinicie o Serviço `pveproxy`**:
    
    Após modificar o arquivo, é necessário reiniciar o serviço `pveproxy` para que as mudanças entrem em vigor:<p></p>
    
    ```console
    systemctl restart pveproxy.service
    ```
	O `pveproxy` é o serviço que controla o front-end da interface web do Proxmox. Reiniciar este serviço aplica as alterações que foram feitas no arquivo JavaScript.<p></p>
	
5.  **Verificar se o Pop-up foi Removido**:
    Acesse a interface web do Proxmox. Se tudo estiver correto, o pop-up de aviso de assinatura não aparecerá mais.
---
