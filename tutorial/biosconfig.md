# BIOS: Configuração de PCI Passthrough na Placa Machinist MR9A

**Aviso**: **Faça estas configurações por sua conta e risco!** Modificar as configurações de BIOS pode afetar a estabilidade do sistema. Tenha certeza de que compreende cada passo antes de realizar as alterações.

O objetivo deste tutorial é configurar o **PCI Passthrough** na placa Machinist Mr9A, permitindo que dispositivos PCI, como GPUs, sejam atribuídos corretamente ao sistema através de grupos **IOMMU**, garantindo que cada dispositivo receba seu próprio código individual.

### Passo a Passo de Configuração

1.  **Configuração do PCI Express Settings**:
    -   **PCI SR-IOV Support**: Ative esta opção para permitir a virtualização de dispositivos PCI, habilitando o suporte a SR-IOV (Single Root I/O Virtualization), que permite que um único dispositivo físico seja dividido em várias instâncias virtuais.
        -   **Opção**: `Enabled`
    -   **BME DMA Mitigation**: Esta configuração ativa a mitigação de DMA (Acesso Direto à Memória), reduzindo possíveis vetores de ataque de dispositivos PCI e protegendo contra DMA malicioso.
        -   **Opção**: `Enabled`
2.  **Configurações no IntelRCSetup**:
    -   **X2APCI**: Ative o **X2APIC**, que melhora a eficiência do sistema na entrega de interrupções, otimizando o gerenciamento de muitos núcleos de CPU em sistemas modernos.
        -   **Opção**: `Enabled`
    -   **X2APIC_OPT_OUT Flag**: Desabilitar essa opção garante que o X2APIC esteja totalmente ativado, sem permitir que o sistema opte por voltar para a versão anterior APIC.
        -   **Opção**: `Disabled`
    -   **VMX (Virtualization Technology)**: Ativar essa tecnologia é essencial para a execução de máquinas virtuais, pois permite que o processador manipule instruções de virtualização diretamente.
        -   **Opção**: `Enabled`
3.  **Configurações Avançadas (Advanced)**:
    -   **Legacy USB Support**: Ativa o suporte para dispositivos USB mais antigos, garantindo que eles possam ser usados no ambiente do sistema operacional, mesmo durante a inicialização.
        -   **Opção**: `Enabled`
    -   **XHCI Hand-off**: Permite que o sistema operacional assuma o controle do controlador USB 3.0 durante a inicialização, ao invés de depender da BIOS para gerenciar dispositivos USB.
        -   **Opção**: `Enabled`
    -   **EHCI Hand-off**: Semelhante ao XHCI, esta opção faz com que o sistema operacional gerencie controladores USB 2.0.
        -   **Opção**: `Enabled`
4.  **Configurações Avançadas de PCI (Advanced PCI)**:
    -   **Relaxed Ordering**: Desativar essa opção assegura que as transações PCI sejam processadas em uma ordem estrita, garantindo maior consistência, especialmente em dispositivos sensíveis a dados.
        -   **Opção**: `Disabled`
    -   **Extended Tag**: Ativar essa opção permite o uso de um espaço de endereçamento maior para transações PCI, o que é importante para dispositivos que realizam um grande volume de transações.
        -   **Opção**: `Enabled`
    -   **No Snoop**: Ativa a otimização para transações PCI, permitindo que certos dispositivos ignorem a coerência de cache para maior desempenho.
        -   **Opção**: `Enabled`
5.  **Configurações Adicionais no IntelRCSetup**:
    -   **Vtd Azalea VCP Optimization**: Esta opção otimiza o passthrough de dispositivos de áudio integrados, garantindo que o áudio funcione corretamente em máquinas virtuais.
        -   **Opção**: `Enabled`
    -   **Intel VT for Directed I/O (VT-d)**: Ativar essa configuração é fundamental para o PCI Passthrough, pois permite a virtualização direta de dispositivos PCI para máquinas virtuais.
        -   **Opção**: `Enabled`
    -   **ACS Control**: O controle ACS garante que dispositivos PCI funcionem em isolamento adequado, o que é crucial para a segurança em ambientes virtualizados.
        -   **Opção**: `Enabled`
    -   **Interrupt Remapping**: Ativa o remapeamento de interrupções para segurança e controle adequado de dispositivos de I/O em ambientes virtualizados.
        -   **Opção**: `Enabled`
    -   **Coherency Support (Non-Isoch)**: Ative para garantir a coerência de cache em dispositivos PCI que não usam isocronismo (não dependem de sincronização de tempo precisa).
        -   **Opção**: `Enabled`
    -   **Coherency Support (Isoch)**: Ative para garantir a coerência de cache em dispositivos PCI que usam isocronismo, como dispositivos de áudio e vídeo em tempo real.
        -   **Opção**: `Enabled`
6.  **IntelRCSetup PCIe ACPI Hot Plug**:
    -   **Per-Port**: Ativar o hot plug em cada porta permite a inserção e remoção de dispositivos PCIe enquanto o sistema está em funcionamento, sem a necessidade de reiniciar, útil para operações de manutenção ou troca de dispositivos PCI.
        -   **Opção**: `Per-Port`

## Resumo
Aqui está a tabela em formato Markdown com as opções e os parâmetros com seus valores configurados para o **PCI Passthrough** na placa **Machinist Mr9A**:

| **Opção**                                | **Parâmetro**                | **Valor**   |
|------------------------------------------|------------------------------|-------------|
| **PCI SR-IOV Support**                   | PCI Express Settings          | `Enabled`   |
| **BME DMA Mitigation**                   | PCI Express Settings          | `Enabled`   |
| **X2APCI**                               | IntelRCSetup                  | `Enabled`   |
| **X2APIC_OPT_OUT Flag**                  | IntelRCSetup                  | `Disabled`  |
| **VMX (Virtualization Technology)**       | IntelRCSetup                  | `Enabled`   |
| **Legacy USB Support**                   | Advanced                      | `Enabled`   |
| **XHCI Hand-off**                        | Advanced                      | `Enabled`   |
| **EHCI Hand-off**                        | Advanced                      | `Enabled`   |
| **Relaxed Ordering**                     | Advanced PCI                  | `Disabled`  |
| **Extended Tag**                         | Advanced PCI                  | `Enabled`   |
| **No Snoop**                             | Advanced PCI                  | `Enabled`   |
| **Vtd Azalea VCP Optimization**          | IntelRCSetup                  | `Enabled`   |
| **Intel VT for Directed I/O (VT-d)**      | IntelRCSetup                  | `Enabled`   |
| **ACS Control**                          | IntelRCSetup                  | `Enabled`   |
| **Interrupt Remapping**                  | IntelRCSetup                  | `Enabled`   |
| **Coherency Support (Non-Isoch)**        | IntelRCSetup                  | `Enabled`   |
| **Coherency Support (Isoch)**            | IntelRCSetup                  | `Enabled`   |
| **PCIe ACPI Hot Plug**                   | IntelRCSetup                  | `Per-Port`  |

Essa tabela resume todas as configurações necessárias para habilitar o **PCI Passthrough** na placa Machinist Mr9A, facilitando a revisão dos parâmetros durante o processo de configuração.

Após seguir esses passos, sua placa **Machinist Mr9A** estará configurada para suportar o **PCI Passthrough**, permitindo que dispositivos PCI, como GPUs, sejam corretamente atribuídos a máquinas virtuais e utilizem IOMMU groups. Teste cuidadosamente cada configuração, e verifique novamente as configurações da BIOS em caso de problemas.
