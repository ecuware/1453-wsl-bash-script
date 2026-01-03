#!/bin/bash
# Module: Interactive Menus
# Description: Main menu system and user interaction
# Dependencies: All other modules

# Configure Git
configure_git() {
    echo -e "\n${BLUE}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}[BİLGİ]${NC} Git yapılandırması başlatılıyor..."
    echo -e "${BLUE}╚═══════════════════════════════════════════════╝${NC}"

    echo -ne "${YELLOW}Git kullanıcı adınızı girin: ${NC}"
    read -r git_user
    echo -ne "${YELLOW}Git e-posta adresinizi girin: ${NC}"
    read -r git_email

    git config --global user.name "$git_user"
    git config --global user.email "$git_email"

    echo -e "${GREEN}[BAŞARILI]${NC} Git yapılandırması tamamlandı!"
    echo -e "  Kullanıcı: $git_user"
    echo -e "  E-posta: $git_email"
}

# Prepare and configure Git
prepare_and_configure_git() {
    update_system
    configure_git
}

# Display main menu
show_menu() {
    echo -e "\n${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                    Ana Kurulum Menüsü                          ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo -e "  ${GREEN}1${NC}) Tam Kurulum (Önerilen)"
    echo -e "  ${GREEN}2${NC}) Hazırlık (Sistem güncelleme + Git)"
    echo -e "  ${GREEN}3${NC}) Python Kurulumu"
    echo -e "  ${GREEN}4${NC}) Pip Güncelleme"
    echo -e "  ${GREEN}5${NC}) Pipx Kurulumu"
    echo -e "  ${GREEN}6${NC}) UV Kurulumu"
    echo -e "  ${GREEN}7${NC}) NVM Kurulumu"
    echo -e "  ${GREEN}8${NC}) Bun.js Kurulumu"
    echo -e "  ${GREEN}9${NC}) PHP Kurulumu"
    echo -e "  ${GREEN}10${NC}) Composer Kurulumu"
    echo -e "  ${GREEN}11${NC}) AI CLI Araçları"
    echo -e "  ${GREEN}12${NC}) AI Framework'leri"
    echo -e "  ${GREEN}13${NC}) AI Framework'leri Kaldır"
    echo -e "  ${GREEN}14${NC}) Go Kurulumu"
    echo -e "  ${GREEN}15${NC}) AI Profilleri Yönetimi"
    echo -e "  ${GREEN}0${NC}) Çıkış"
    echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}"
}

# Show mode selection menu
show_mode_selection() {
    clear
    echo -e "${CYAN}"
    cat << 'EOF'
    ╔════════════════════════════════════════════════════════════════╗
    ║                                                                ║
    ║           🎯 1453.AI - MOD SEÇİMİNİ YAPIN 🎯                  ║
    ║                                                                ║
    ╚════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    echo -e "${YELLOW}Hangi kurulum modunu tercih edersiniz?${NC}"
    echo ""
    echo -e "  ${GREEN}1${NC}) ${CYAN}🚀 QUICK START MODE (Önerilen)${NC}"
    echo -e "     ${YELLOW}→ Vibe coder'lar ve yeni başlayanlar için${NC}"
    echo -e "     ${YELLOW}→ Basit sorular, otomatik kurulum${NC}"
    echo -e "     ${YELLOW}→ Sizi yormaz, sadece gerekli araçları kurar${NC}"
    echo ""
    echo -e "  ${GREEN}2${NC}) ${CYAN}⚙️  ADVANCED MODE${NC}"
    echo -e "     ${YELLOW}→ İleri düzey kullanıcılar için${NC}"
    echo -e "     ${YELLOW}→ Detaylı kontrol, her aracı ayrı seçin${NC}"
    echo -e "     ${YELLOW}→ 14 farklı kurulum seçeneği${NC}"
    echo ""
    echo -e "  ${GREEN}0${NC}) ${CYAN}❌ Çıkış${NC}"
    echo ""
    echo -e "${CYAN}────────────────────────────────────────────────────────────${NC}"
    echo ""
    echo -ne "${YELLOW}Seçiminiz (0-2): ${NC}"
    read -r mode_choice

    case $mode_choice in
        1)
            echo ""
            run_quickstart_mode
            if [ $? -eq 0 ]; then
                # User wants to continue, show mode selection again
                show_mode_selection
            fi
            ;;
        2)
            # Run advanced mode
            run_advanced_mode
            ;;
        0)
            echo -e "\n${GREEN}[BİLGİ]${NC} Kurulum scripti sonlandırılıyor..."
            exit 0
            ;;
        *)
            echo -e "${RED}[HATA]${NC} Geçersiz seçim! Lütfen 0-2 arasında bir değer girin."
            sleep 2
            show_mode_selection
            ;;
    esac
}

# Advanced mode menu (current menu system)
show_advanced_menu() {
    clear
    show_banner
    show_menu
}

# Main program loop - Advanced Mode
run_advanced_mode() {
    # Detect package manager on startup
    detect_package_manager

    # Track installed components
    local NVM_INSTALLED=false
    local PYTHON_INSTALLED=false

    while true; do
        show_advanced_menu
        echo -ne "\n${YELLOW}Seçiminizi yapın (virgülle ayırarak birden fazla seçebilirsiniz): ${NC}"
        read -r choices

        # Convert choices to array
        IFS=',' read -ra choice_array <<< "$choices"

        for choice in "${choice_array[@]}"; do
            # Trim whitespace
            choice=$(echo "$choice" | xargs)

            case $choice in
                1)
                    echo -e "\n${BLUE}╔═══════════════════════════════════════════════╗${NC}"
                    echo -e "${BLUE}║           TAM KURULUM BAŞLATILIYOR            ║${NC}"
                    echo -e "${BLUE}╚═══════════════════════════════════════════════╝${NC}"
                    update_system
                    configure_git
                    install_python && PYTHON_INSTALLED=true
                    install_pip
                    install_pipx
                    install_uv
                    install_nvm && NVM_INSTALLED=true
                    install_bun
                    install_composer
                    install_claude_code
                    install_github_cli
                    install_go
                    echo -e "\n${GREEN}[BAŞARILI]${NC} Tam kurulum tamamlandı!"
                    ;;
                2) prepare_and_configure_git ;;
                3) install_python && PYTHON_INSTALLED=true ;;
                4) install_pip ;;
                5) install_pipx ;;
                6) install_uv ;;
                7) install_nvm && NVM_INSTALLED=true ;;
                8) install_bun ;;
                9) install_php_version_menu ;;
                10) install_composer ;;
                11) install_ai_cli_tools_menu ;;
                12) install_ai_frameworks_menu ;;
                13) remove_ai_frameworks_menu ;;
                14) install_go_menu ;;
                15) manage_profiles_menu ;;
                0)
                    echo -e "\n${GREEN}[BİLGİ]${NC} Ana menüye dönülüyor..."
                    sleep 1
                    show_mode_selection
                    ;;
                *)
                    echo -e "${RED}[HATA]${NC} Geçersiz seçim: $choice"
                    ;;
            esac
        done

        # Check if critical tools were installed
        if [ "$NVM_INSTALLED" = true ] || [ "$PYTHON_INSTALLED" = true ]; then
            echo -e "\n${YELLOW}[ÖNEMLİ]${NC} Yeni kurulumlar tespit edildi."
            echo -e "${CYAN}[İPUCU]${NC} Değişikliklerin aktif olması için:"
            echo -e "  1) ${GREEN}source ~/.bashrc${NC} veya ${GREEN}source ~/.zshrc${NC} komutunu çalıştırın"
            echo -e "  2) Ya da terminali yeniden başlatın"
        fi

        echo -e "\n${YELLOW}Devam etmek için Enter'a basın...${NC}"
        read -r
    done
}

# Help mesajı göster
show_help() {
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║        1453.AI WSL Setup Script - Kullanım Kılavuzu           ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${GREEN}Hızlı Profil Komutları:${NC}"
    echo -e "  ${YELLOW}$0 claude${NC}          Claude Developer profili kur"
    echo -e "  ${YELLOW}$0 gemini${NC}          Gemini Developer profili kur"
    echo -e "  ${YELLOW}$0 qwen${NC}            Qwen Developer profili kur"
    echo -e "  ${YELLOW}$0 multi${NC}           Multi-AI Developer profili kur (Önerilen)"
    echo -e "  ${YELLOW}$0 code${NC}            AI Code Assistant profili kur"
    echo -e "  ${YELLOW}$0 researcher${NC}      AI Researcher profili kur"
    echo -e "  ${YELLOW}$0 backend${NC}         AI Backend Developer profili kur"
    echo -e "  ${YELLOW}$0 frontend${NC}        AI Frontend Developer profili kur"
    echo ""
    echo -e "${GREEN}Kullanılabilir Profiller:${NC}"
    echo -e "  • ${CYAN}claude${NC}      - Claude Code CLI + SuperClaude + Python"
    echo -e "  • ${CYAN}gemini${NC}      - Gemini CLI + SuperGemini + Python"
    echo -e "  • ${CYAN}qwen${NC}        - Qwen CLI + SuperQwen + Python"
    echo -e "  • ${CYAN}multi${NC}       - Tüm AI Tools + Frameworks (En kapsamlı)"
    echo -e "  • ${CYAN}code${NC}        - Claude + Copilot + Qoder (Kod üretimi)"
    echo -e "  • ${CYAN}researcher${NC}   - Tüm AI Frameworks (Araştırma)"
    echo -e "  • ${CYAN}backend${NC}     - Python + Go + AI Tools (Backend)"
    echo -e "  • ${CYAN}frontend${NC}    - Node.js + AI Tools (Frontend)"
    echo ""
    echo -e "${GREEN}Normal Mod:${NC}"
    echo -e "  ${YELLOW}$0${NC}                    İnteraktif menüyü aç"
    echo -e "  ${YELLOW}$0 --help${NC} veya ${YELLOW}$0 -h${NC}    Bu yardım mesajını göster"
    echo ""
    echo -e "${CYAN}Örnekler:${NC}"
    echo -e "  ${GREEN}$0 multi${NC}              # Multi-AI profili direkt kur"
    echo -e "  ${GREEN}$0 claude${NC}             # Claude profili direkt kur"
    echo -e "  ${GREEN}$0${NC}                    # İnteraktif menü"
    echo ""
}

# Main program loop - entry point
main() {
    # Komut satırı argümanlarını kontrol et
    if [ $# -gt 0 ]; then
        # Help komutları
        case "$1" in
            --help|-h|help)
                show_help
                exit 0
                ;;
        esac
        
        # Diğer tüm argümanlar profil komutları olarak kabul edilir
        # install_profile_by_name normalizasyon yapar, doğrulama yapar ve hata kontrolü yapar
        clear
        show_banner
        install_profile_by_name "$1"
        exit $?
    fi
    
    # Normal menü akışı (argüman yoksa)
    show_mode_selection
}

# Export functions for use in other modules
export -f configure_git
export -f prepare_and_configure_git
export -f show_menu
export -f show_mode_selection
export -f show_advanced_menu
export -f run_advanced_mode
export -f run_quickstart_mode
export -f main
