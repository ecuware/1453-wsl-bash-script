#!/bin/bash
# Module: AI Profiles
# Description: AI-focused profile management system
# Dependencies: All other modules

# Profil dizini
PROFILES_DIR="$HOME/.1453-wsl-setup/profiles"
mkdir -p "$PROFILES_DIR"

# Genel API Key yapılandırma fonksiyonu
# Kullanım: configure_api_key "Servis Adı" "ORTAM_DEGISKENI" "https://console.url.com" (opsiyonel)
configure_api_key() {
    local service_name="$1"
    local env_var_name="$2"
    local console_url="${3:-}"  # Opsiyonel URL
    
    echo -e "\n${YELLOW}[BİLGİ]${NC} ${service_name} API Key yapılandırması"
    echo -ne "${CYAN}API Key'iniz var mı? (e/E=Evet, Enter=Hayır): ${NC}"
    read -r has_key
    
    if [[ "$has_key" =~ ^[eE]$ ]]; then
        echo -ne "${YELLOW}${service_name} API Key'inizi girin: ${NC}"
        read -r api_key
        if [ -n "$api_key" ]; then
            echo "" >> "$HOME/.bashrc"
            echo "# ${service_name} API Key" >> "$HOME/.bashrc"
            echo "export ${env_var_name}='$api_key'" >> "$HOME/.bashrc"
            [ -f "$HOME/.zshrc" ] && echo "export ${env_var_name}='$api_key'" >> "$HOME/.zshrc"
            echo -e "${GREEN}[BAŞARILI]${NC} API Key kaydedildi!"
        fi
    else
        echo -e "${CYAN}[BİLGİ]${NC} API Key'i daha sonra ayarlayabilirsiniz:"
        echo -e "  ${GREEN}export ${env_var_name}='your-key'${NC}"
        if [ -n "$console_url" ]; then
            echo -e "  ${GREEN}${console_url}${NC}"
        fi
    fi
}

# API Key yapılandırma fonksiyonları (genel fonksiyonu kullanarak)
configure_anthropic_api_key() {
    configure_api_key "Anthropic" "ANTHROPIC_API_KEY" "https://console.anthropic.com/"
}

configure_google_ai_api_key() {
    configure_api_key "Google AI" "GOOGLE_AI_API_KEY" "https://makersuite.google.com/app/apikey"
}

configure_qwen_api_key() {
    configure_api_key "Qwen" "QWEN_API_KEY"
}

configure_all_api_keys() {
    configure_anthropic_api_key
    configure_google_ai_api_key
    configure_qwen_api_key
}

# Claude Developer Profili
install_claude_developer_profile() {
    echo -e "\n${BLUE}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║      🤖 Claude Developer Profili Kuruluyor    ║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════╝${NC}"
    
    # Temel araçlar
    update_system
    configure_git
    
    # Python ekosistemi
    install_python
    install_pip
    install_pipx
    install_uv
    
    # AI araçları
    install_claude_code
    install_superclaude
    install_github_cli
    
    # API Key yapılandırması
    configure_anthropic_api_key
    
    echo -e "\n${GREEN}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║     ✅ Claude Developer Profili Kuruldu!       ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════╝${NC}"
    echo -e "\n${CYAN}[BİLGİ]${NC} Kurulu araçlar:"
    echo -e "  ✓ Claude Code CLI"
    echo -e "  ✓ SuperClaude Framework"
    echo -e "  ✓ Python + pipx + UV"
    echo -e "  ✓ GitHub CLI"
    echo -e "\n${YELLOW}[İPUCU]${NC} Kullanıma başlamak için:"
    echo -e "  ${GREEN}source ~/.bashrc${NC} (veya terminali yeniden başlatın)"
    echo -e "  ${GREEN}claude-code --version${NC}"
}

# Gemini Developer Profili
install_gemini_developer_profile() {
    echo -e "\n${BLUE}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║      🌟 Gemini Developer Profili Kuruluyor     ║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════╝${NC}"
    
    # Temel araçlar
    update_system
    configure_git
    
    # Python ekosistemi
    install_python
    install_pip
    install_pipx
    install_uv
    
    # AI araçları
    install_gemini_cli
    install_supergemini
    install_github_cli
    
    # API Key yapılandırması
    configure_google_ai_api_key
    
    echo -e "\n${GREEN}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║     ✅ Gemini Developer Profili Kuruldu!      ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════╝${NC}"
    echo -e "\n${CYAN}[BİLGİ]${NC} Kurulu araçlar:"
    echo -e "  ✓ Gemini CLI"
    echo -e "  ✓ SuperGemini Framework"
    echo -e "  ✓ Python + pipx + UV"
    echo -e "  ✓ GitHub CLI"
    echo -e "\n${YELLOW}[İPUCU]${NC} Kullanıma başlamak için:"
    echo -e "  ${GREEN}source ~/.bashrc${NC} (veya terminali yeniden başlatın)"
}

# Qwen Developer Profili
install_qwen_developer_profile() {
    echo -e "\n${BLUE}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║      🚀 Qwen Developer Profili Kuruluyor       ║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════╝${NC}"
    
    # Temel araçlar
    update_system
    configure_git
    
    # Python ekosistemi
    install_python
    install_pip
    install_pipx
    install_uv
    
    # AI araçları
    install_qwen_cli
    install_superqwen
    install_github_cli
    
    # API Key yapılandırması
    configure_qwen_api_key
    
    echo -e "\n${GREEN}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║     ✅ Qwen Developer Profili Kuruldu!       ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════╝${NC}"
    echo -e "\n${CYAN}[BİLGİ]${NC} Kurulu araçlar:"
    echo -e "  ✓ Qwen CLI"
    echo -e "  ✓ SuperQwen Framework"
    echo -e "  ✓ Python + pipx + UV"
    echo -e "  ✓ GitHub CLI"
    echo -e "\n${YELLOW}[İPUCU]${NC} Kullanıma başlamak için:"
    echo -e "  ${GREEN}source ~/.bashrc${NC} (veya terminali yeniden başlatın)"
}

# Multi-AI Developer Profili (En kapsamlı)
install_multi_ai_developer_profile() {
    echo -e "\n${BLUE}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║    🎯 Multi-AI Developer Profili Kuruluyor   ║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════╝${NC}"
    
    # Temel araçlar
    update_system
    configure_git
    
    # Python ekosistemi
    install_python
    install_pip
    install_pipx
    install_uv
    
    # Node.js (bazı AI araçları için)
    install_nvm
    
    # Tüm AI CLI Tools
    echo -e "\n${YELLOW}[BİLGİ]${NC} AI CLI araçları kuruluyor..."
    install_claude_code
    install_gemini_cli
    install_qwen_cli
    install_opencode_cli
    install_copilot_cli
    install_qoder_cli
    install_github_cli
    
    # Tüm AI Frameworks
    echo -e "\n${YELLOW}[BİLGİ]${NC} AI Framework'leri kuruluyor..."
    install_supergemini
    install_superqwen
    install_superclaude
    
    # API Key yapılandırması
    echo -e "\n${YELLOW}[BİLGİ]${NC} API Key yapılandırması..."
    configure_all_api_keys
    
    echo -e "\n${GREEN}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║   ✅ Multi-AI Developer Profili Kuruldu!    ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════╝${NC}"
    echo -e "\n${CYAN}[BİLGİ]${NC} Kurulu araçlar:"
    echo -e "  ✓ Tüm AI CLI Tools (Claude, Gemini, Qwen, OpenCode, Copilot, Qoder)"
    echo -e "  ✓ Tüm AI Frameworks (SuperClaude, SuperGemini, SuperQwen)"
    echo -e "  ✓ Python + pipx + UV"
    echo -e "  ✓ Node.js (NVM)"
    echo -e "  ✓ GitHub CLI"
    echo -e "\n${YELLOW}[İPUCU]${NC} Kullanıma başlamak için:"
    echo -e "  ${GREEN}source ~/.bashrc${NC} (veya terminali yeniden başlatın)"
}

# AI Code Assistant Profili
install_ai_code_assistant_profile() {
    echo -e "\n${BLUE}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║   💻 AI Code Assistant Profili Kuruluyor     ║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════╝${NC}"
    
    # Temel araçlar
    update_system
    configure_git
    
    # Python ekosistemi
    install_python
    install_pip
    install_pipx
    
    # Node.js
    install_nvm
    
    # AI Code Assistant araçları
    install_claude_code
    install_copilot_cli
    install_qoder_cli
    install_opencode_cli
    install_github_cli
    
    # API Key yapılandırması
    configure_anthropic_api_key
    
    echo -e "\n${GREEN}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  ✅ AI Code Assistant Profili Kuruldu!       ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════╝${NC}"
    echo -e "\n${CYAN}[BİLGİ]${NC} Kurulu araçlar:"
    echo -e "  ✓ Claude Code CLI"
    echo -e "  ✓ GitHub Copilot CLI"
    echo -e "  ✓ Qoder CLI"
    echo -e "  ✓ OpenCode CLI"
    echo -e "  ✓ Python + pipx"
    echo -e "  ✓ Node.js (NVM)"
    echo -e "  ✓ GitHub CLI"
}

# AI Researcher Profili
install_ai_researcher_profile() {
    echo -e "\n${BLUE}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║      🔬 AI Researcher Profili Kuruluyor       ║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════╝${NC}"
    
    # Temel araçlar
    update_system
    configure_git
    
    # Python ekosistemi (araştırma için kritik)
    install_python
    install_pip
    install_pipx
    install_uv
    
    # Tüm AI Frameworks
    install_supergemini
    install_superqwen
    install_superclaude
    
    # AI CLI Tools
    install_claude_code
    install_gemini_cli
    install_qwen_cli
    install_github_cli
    
    # API Key yapılandırması
    configure_all_api_keys
    
    echo -e "\n${GREEN}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║     ✅ AI Researcher Profili Kuruldu!         ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════╝${NC}"
    echo -e "\n${CYAN}[BİLGİ]${NC} Kurulu araçlar:"
    echo -e "  ✓ Tüm AI Frameworks (SuperClaude, SuperGemini, SuperQwen)"
    echo -e "  ✓ AI CLI Tools (Claude, Gemini, Qwen)"
    echo -e "  ✓ Python + pipx + UV (araştırma için)"
    echo -e "  ✓ GitHub CLI"
}

# AI Backend Developer Profili
install_ai_backend_developer_profile() {
    echo -e "\n${BLUE}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║  🏗️  AI Backend Developer Profili Kuruluyor  ║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════╝${NC}"
    
    # Temel araçlar
    update_system
    configure_git
    
    # Backend dilleri
    install_python
    install_pip
    install_pipx
    install_uv
    install_go
    
    # AI araçları
    install_claude_code
    install_superclaude
    install_github_cli
    
    # API Key yapılandırması
    configure_anthropic_api_key
    
    echo -e "\n${GREEN}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║ ✅ AI Backend Developer Profili Kuruldu!      ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════╝${NC}"
    echo -e "\n${CYAN}[BİLGİ]${NC} Kurulu araçlar:"
    echo -e "  ✓ Claude Code CLI + SuperClaude"
    echo -e "  ✓ Python + pipx + UV"
    echo -e "  ✓ Go language"
    echo -e "  ✓ GitHub CLI"
}

# AI Frontend Developer Profili
install_ai_frontend_developer_profile() {
    echo -e "\n${BLUE}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║  🎨 AI Frontend Developer Profili Kuruluyor  ║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════╝${NC}"
    
    # Temel araçlar
    update_system
    configure_git
    
    # Frontend araçları
    install_nvm
    install_bun
    
    # AI Code Assistant araçları
    install_claude_code
    install_copilot_cli
    install_qoder_cli
    install_github_cli
    
    # Python (bazı AI araçları için)
    install_python
    install_pip
    install_pipx
    
    # API Key yapılandırması
    configure_anthropic_api_key
    
    echo -e "\n${GREEN}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║ ✅ AI Frontend Developer Profili Kuruldu!     ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════╝${NC}"
    echo -e "\n${CYAN}[BİLGİ]${NC} Kurulu araçlar:"
    echo -e "  ✓ Node.js (NVM) + Bun.js"
    echo -e "  ✓ Claude Code CLI"
    echo -e "  ✓ GitHub Copilot CLI"
    echo -e "  ✓ Qoder CLI"
    echo -e "  ✓ Python + pipx"
    echo -e "  ✓ GitHub CLI"
}

# Hazır AI profillerini göster
show_ai_profiles() {
    echo -e "\n${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║           AI GELİŞTİRME PROFİLLERİ                            ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "  ${GREEN}1${NC}) 🤖 ${YELLOW}Claude Developer${NC}"
    echo -e "     ${CYAN}→ Claude Code CLI + SuperClaude${NC}"
    echo -e "     ${CYAN}→ Python ekosistemi${NC}"
    echo ""
    echo -e "  ${GREEN}2${NC}) 🌟 ${YELLOW}Gemini Developer${NC}"
    echo -e "     ${CYAN}→ Gemini CLI + SuperGemini${NC}"
    echo -e "     ${CYAN}→ Google AI SDK${NC}"
    echo ""
    echo -e "  ${GREEN}3${NC}) 🚀 ${YELLOW}Qwen Developer${NC}"
    echo -e "     ${CYAN}→ Qwen CLI + SuperQwen${NC}"
    echo -e "     ${CYAN}→ Alibaba AI araçları${NC}"
    echo ""
    echo -e "  ${GREEN}4${NC}) 🎯 ${YELLOW}Multi-AI Developer${NC} ${GREEN}(Önerilen)${NC}"
    echo -e "     ${CYAN}→ Tüm AI CLI Tools + Frameworks${NC}"
    echo -e "     ${CYAN}→ Komple AI geliştirme ortamı${NC}"
    echo ""
    echo -e "  ${GREEN}5${NC}) 💻 ${YELLOW}AI Code Assistant${NC}"
    echo -e "     ${CYAN}→ Kod üretimi odaklı araçlar${NC}"
    echo -e "     ${CYAN}→ Claude + Copilot + Qoder${NC}"
    echo ""
    echo -e "  ${GREEN}6${NC}) 🔬 ${YELLOW}AI Researcher${NC}"
    echo -e "     ${CYAN}→ Araştırma ve analiz araçları${NC}"
    echo -e "     ${CYAN}→ Tüm AI Frameworks${NC}"
    echo ""
    echo -e "  ${GREEN}7${NC}) 🏗️  ${YELLOW}AI Backend Developer${NC}"
    echo -e "     ${CYAN}→ AI API entegrasyonları${NC}"
    echo -e "     ${CYAN}→ Python + Go + AI Tools${NC}"
    echo ""
    echo -e "  ${GREEN}8${NC}) 🎨 ${YELLOW}AI Frontend Developer${NC}"
    echo -e "     ${CYAN}→ Frontend AI araçları${NC}"
    echo -e "     ${CYAN}→ Node.js + AI CLI Tools${NC}"
    echo ""
    echo -e "  ${GREEN}0${NC}) ${CYAN}Ana menüye dön${NC}"
    echo ""
    echo -e "${CYAN}────────────────────────────────────────────────────────────${NC}"
}

# Profil yönetim menüsü
manage_profiles_menu() {
    while true; do
        clear
        show_banner
        show_ai_profiles
        echo -ne "\n${YELLOW}Profil seçin (0-8): ${NC}"
        read -r choice
        
        # Hangi kurulum fonksiyonunun çağrılacağını belirle
        local install_function=""
        case $choice in
            1) install_function="install_claude_developer_profile" ;;
            2) install_function="install_gemini_developer_profile" ;;
            3) install_function="install_qwen_developer_profile" ;;
            4) install_function="install_multi_ai_developer_profile" ;;
            5) install_function="install_ai_code_assistant_profile" ;;
            6) install_function="install_ai_researcher_profile" ;;
            7) install_function="install_ai_backend_developer_profile" ;;
            8) install_function="install_ai_frontend_developer_profile" ;;
            0) return ;;
            *)
                echo -e "${RED}[HATA]${NC} Geçersiz seçim! Lütfen 0-8 arasında bir değer girin."
                sleep 2
                continue
                ;;
        esac
        
        # Seçilen fonksiyonu çağır ve yürütmeyi duraklat
        if [ -n "$install_function" ]; then
            $install_function
            echo -e "\n${YELLOW}Devam etmek için Enter'a basın...${NC}"
            read -r
        fi
    done
}

# Hızlı profil komutları - profil ismini alıp kurulum yapar
install_profile_by_name() {
    local profile_name="$1"
    
    # Paket yöneticisini tespit et
    detect_package_manager
    
    # Profil ismini normalize et (küçük harfe çevir, tireleri alt çizgiye çevir, boşlukları alt çizgiye çevir)
    profile_name=$(echo "$profile_name" | tr '[:upper:]' '[:lower:]' | tr '-' '_' | tr ' ' '_')
    
    case "$profile_name" in
        claude|claude_developer|claude_dev)
            install_claude_developer_profile
            ;;
        gemini|gemini_developer|gemini_dev)
            install_gemini_developer_profile
            ;;
        qwen|qwen_developer|qwen_dev)
            install_qwen_developer_profile
            ;;
        multi|multi_ai|multi_ai_developer|multi_ai_dev)
            install_multi_ai_developer_profile
            ;;
        code|code_assistant|ai_code|ai_code_assistant)
            install_ai_code_assistant_profile
            ;;
        researcher|ai_researcher|research)
            install_ai_researcher_profile
            ;;
        backend|ai_backend|backend_dev|ai_backend_developer)
            install_ai_backend_developer_profile
            ;;
        frontend|ai_frontend|frontend_dev|ai_frontend_developer)
            install_ai_frontend_developer_profile
            ;;
        *)
            echo -e "${RED}[HATA]${NC} Bilinmeyen profil: $1"
            echo ""
            echo -e "${YELLOW}Kullanılabilir profiller:${NC}"
            echo -e "  ${GREEN}claude${NC}      - Claude Developer"
            echo -e "  ${GREEN}gemini${NC}      - Gemini Developer"
            echo -e "  ${GREEN}qwen${NC}        - Qwen Developer"
            echo -e "  ${GREEN}multi${NC}       - Multi-AI Developer (Önerilen)"
            echo -e "  ${GREEN}code${NC}        - AI Code Assistant"
            echo -e "  ${GREEN}researcher${NC}   - AI Researcher"
            echo -e "  ${GREEN}backend${NC}     - AI Backend Developer"
            echo -e "  ${GREEN}frontend${NC}    - AI Frontend Developer"
            echo ""
            echo -e "${CYAN}Kullanım:${NC} $0 <profil-adi>"
            echo -e "${CYAN}Örnek:${NC}   $0 multi"
            return 1
            ;;
    esac
}

# Export functions for use in other modules
export -f configure_anthropic_api_key
export -f configure_google_ai_api_key
export -f configure_qwen_api_key
export -f configure_all_api_keys
export -f install_claude_developer_profile
export -f install_gemini_developer_profile
export -f install_qwen_developer_profile
export -f install_multi_ai_developer_profile
export -f install_ai_code_assistant_profile
export -f install_ai_researcher_profile
export -f install_ai_backend_developer_profile
export -f install_ai_frontend_developer_profile
export -f show_ai_profiles
export -f manage_profiles_menu
export -f install_profile_by_name

