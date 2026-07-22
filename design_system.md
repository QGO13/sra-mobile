# Design System V2 - Variables CSS

Voici le fichier de style CSS regroupant l'ensemble de vos choix pour la charte graphique V2 de l'Aparthotel. Vous pouvez l'importer ou l'intégrer directement dans vos fichiers globaux (comme `globals.css`) pour centraliser toute l'identité visuelle.

```css
/* ==========================================================================
   SRA HOTEL - DESIGN SYSTEM V2 (MOCKUP UPDATE)
   Centralisation des variables CSS (Couleurs, Typographies, Formes, Ombres)
   ========================================================================== */

:root {
  /* ── 1. COULEURS PRINCIPALES (PALETTE) ───────────────────────── */
  
  /* Arrière-plan global doux et chaleureux */
  --cream: #FAF8F5;          
  
  /* Textes principaux et cartes sombres */
  --anthracite: #1A1A1A;     
  --anthracite-soft: #242322;
  
  /* Dégradés et couleurs d'accentuation dorées */
  --gold-1: #D4AF37;         
  --gold-2: #AA7C11;         
  --bronze: #8C6221;
  
  /* Couleurs de surface et d'appoint */
  --white: #FFFFFF;          
  --ink-muted: rgba(26, 26, 26, 0.62);
  --line: rgba(140, 98, 33, 0.25);
  
  /* ── 2. TYPOGRAPHIES (POLICES) ───────────────────────────────── */
  
  /* Police pour les Titres (Élégance, Tradition) */
  --font-serif: 'Cormorant Garamond', serif;
  
  /* Police pour le Corps de texte et l'UI (Modernité, Lisibilité) */
  --font-sans: 'Montserrat', sans-serif;
  
  /* ── 3. FORMES & ARRONDIS (BORDER RADIUS) ────────────────────── */
  
  /* Champs de saisie (Inputs) */
  --radius-sm: 10px;         
  
  /* Cartes moyennes (Articles Panier, etc.) */
  --radius-md: 18px;         
  
  /* Grandes cartes et conteneurs principaux */
  --radius-lg: 24px;         
  --radius-xl: 28px;         
  
  /* Boutons pilules et puces de filtres */
  --radius-pill: 999px;      
  
  /* ── 4. OMBRES & FLOTTAISONS (BOX SHADOWS) ───────────────────── */
  
  /* Ombre standard pour les cartes blanches sur fond crème */
  --shadow-card: 0 14px 34px -18px rgba(26, 26, 26, 0.35);
  
  /* Ombre plus diffuse pour les grandes sections ou le survol */
  --shadow-soft: 0 20px 50px -20px rgba(26, 26, 26, 0.25);
  
  /* Ombre dorée incandescente (Boutons dorés) */
  --shadow-gold: 0 10px 24px -8px rgba(170, 124, 17, 0.55);
  --shadow-gold-hover: 0 16px 30px -10px rgba(170, 124, 17, 0.60);
}

/* ==========================================================================
   CLASSES UTILITAIRES (HELPERS) V2
   ========================================================================== */

/* Bouton principal (Pilule + Dégradé Doré + Lévitation) */
.btn-v2-primary {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  padding: 14px 30px;
  background: linear-gradient(120deg, var(--gold-1), var(--gold-2));
  color: var(--white);
  border: none;
  border-radius: var(--radius-pill);
  box-shadow: var(--shadow-gold);
  font-family: var(--font-sans);
  font-size: 11px;
  font-weight: 600;
  letter-spacing: 0.16em;
  text-transform: uppercase;
  text-decoration: none;
  cursor: pointer;
  transition: transform 0.25s ease, box-shadow 0.25s ease;
}

.btn-v2-primary:hover {
  transform: translateY(-2px);
  box-shadow: var(--shadow-gold-hover);
}

/* Carte standard (Fond blanc, Arrondis généreux, Ombre) */
.card-v2 {
  background: var(--white);
  border: none;
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-card);
  overflow: hidden;
}

/* Champ de saisie (Input) */
.input-v2 {
  background: var(--white);
  border: 1px solid rgba(26, 26, 26, 0.15);
  border-radius: var(--radius-sm);
  padding: 14px 20px;
  font-family: var(--font-sans);
  font-size: 0.92rem;
  color: var(--anthracite);
  outline: none;
  transition: border-color 0.3s ease, box-shadow 0.3s ease;
}

.input-v2:focus {
  border-color: var(--gold-1);
  box-shadow: 0 0 0 3px rgba(197, 152, 91, 0.1);
}
```

> [!TIP]
> Notez que la majorité de ces variables sont déjà partiellement intégrées dans votre fichier actuel `app/globals.css`. Ce document vous permet d'avoir **une vue globale et centralisée** des choix de la refonte (notamment l'introduction des ombres dorées et des boutons pilules) pour faciliter le développement des futures pages.
