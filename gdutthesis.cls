\NeedsTeXFormat{LaTeX2e}[2020/10/01]
\RequirePackage{expl3}
\ProvidesExplClass{gdutthesis}
  {2022/02/28}{v0.1d}{Thesis Template for Guangdong University of Technology}
\RequirePackage { xtemplate, l3keys2e }
\msg_new:nnn { gdutthesis } { l3-too-old }
  {
    Package~ "#1"~ is~ too~ old. \\\\
    Please~ update~ an~ up-to-date~ version~ of~ the~ bundles \\
    "l3kernel"~ and~ "l3packages"~ using~ your~ TeX~ package \\
    manager~ or~ from~ CTAN.
  }
\clist_map_inline:nn { xtemplate, l3keys2e }
  {
    \@ifpackagelater {#1} { 2020/07/17 }
      { } { \msg_error:nnn { gdutthesis } { l3-too-old } {#1} }
  }
\msg_new:nnn { gdutthesis } { unsupported-engine }
  {
    The~ gdutthesis~ class~ requires~ either~ XeTeX~ or~ LuaTeX. \\\\
    "#1"~ is~ not~ supported~ at~ present.~ You~ must~ change \\
    your~ typesetting~ engine~ to~ "xelatex"~ or~ "lualatex".
  }
\sys_if_engine_xetex:F
  {
    \sys_if_engine_luatex:F
      {
        \msg_fatal:nnx { gdutthesis } { unsupported-engine }
          { \c_sys_engine_str }
      }
  }
\int_new:N \g__gdut_thesis_type_int
\clist_new:N \g__gdut_to_ctexbook_clist
\clist_new:N \g__gdut_to_hyperref_clist
\bool_new:N \g__gdut_draft_bool
\cs_generate_variant:Nn \cs_generate_variant:Nn { cn }
\cs_generate_variant:Nn \file_input:n           { V  }
\cs_generate_variant:Nn \int_to_arabic:n        { v  }
\cs_generate_variant:Nn \keys_define:nn         { nx }
\cs_generate_variant:Nn \tl_map_inline:nn       { xn }
\prg_generate_conditional_variant:Nnn \tl_if_eq:nn { Vn } { T, TF }
\cs_new:Npn \__gdut_symbol:n #1 { \tex_char:D #1 \scan_stop: }
\cs_new_protected:Npn \__gdut_gadd_ltxhook:nn #1#2
  { \hook_gput_code:nnn {#1} { . } {#2} }
\hook_gset_rule:nnnn { begindocument/before } { . } { < } { xeCJK }
\cs_new_protected:Npn \__gdut_appto_cmd:Nn #1#2
  {
    \ctex_appto_cmd:NnnTF #1 { } {#2}
      { } { \ctex_patch_failure:N #1 }
  }
\cs_new_protected:Npn \__gdut_define_fn_style:nn #1#2
  { \tl_const:cn { c__gdut_fn_style_ #1 _tl } {#2} }
\cs_new_protected:Npn \__gdut_define_punct:nn #1#2
  { \tl_const:cn { c__gdut_ #1 _tl } { \__gdut_symbol:n {#2} } }
\cs_new_protected:Npn \__gdut_define_name:nn #1#2
  { \tl_const:cn { c__gdut_name_ #1 _tl } {#2} }
\cs_new_protected:Npn \__gdut_define_name:nnn #1#2#3
  {
    \tl_const:cn { c__gdut_name_ #1    _tl } {#2}
    \tl_const:cn { c__gdut_name_ #1 _en_tl } {#3}
  }
\cs_new:Npn \__gdut_msg_new:nn  { \msg_new:nnn      { gdutthesis } }
\cs_new:Npn \__gdut_error:n     { \msg_error:nn     { gdutthesis } }
\cs_new:Npn \__gdut_error:nn    { \msg_error:nnn    { gdutthesis } }
\cs_new:Npn \__gdut_error:nx    { \msg_error:nnx    { gdutthesis } }
\cs_new:Npn \__gdut_error:nnn   { \msg_error:nnnn   { gdutthesis } }
\cs_new:Npn \__gdut_error:nnnn  { \msg_error:nnnnn  { gdutthesis } }
\cs_new:Npn \__gdut_warning:n   { \msg_warning:nn   { gdutthesis } }
\cs_new:Npn \__gdut_warning:nn  { \msg_warning:nnn  { gdutthesis } }
\cs_new:Npn \__gdut_warning:nxx { \msg_warning:nnxx { gdutthesis } }
\cs_new:Npn \__gdut_info:nx     { \msg_info:nnx     { gdutthesis } }
\keys_define:nn { gdut / option }
  {
    type .choice:,
    type .value_required:n = true,
    type .choices:nn =
      { doctor, master, promaster }
      { \int_set_eq:NN \g__gdut_thesis_type_int \l_keys_choice_int },
    type .initial:n = master,
    draft .choice:,
    draft / true  .code:n =
      {
        \bool_set_true:N     \g__gdut_draft_bool
        \clist_gput_right:Nn \g__gdut_to_ctexbook_clist { draft }
      },
    draft / false .code:n =
      { \bool_set_false:N    \g__gdut_draft_bool },
    draft .default:n = true,
    draft .initial:n = false,
    unknown .code:n = { \__gdut_error:n { unknown-option } }
  }
\__gdut_msg_new:nn { unknown-option }
  { Class~ option~ "\l_keys_key_str"~ is~ unknown. }
\ProcessKeysOptions { gdut / option }
\tl_const:Nn \__gdut_thesis_type
  {
    \clist_item:Nn \c__gdut_thesis_type_clist
      { \g__gdut_thesis_type_int }
  }
\tl_const:Nn \__gdut_thesis_en_type
  {
    \clist_item:Nn \c__gdut_thesis_type_en_clist
      { \g__gdut_thesis_type_int }
  }
\tl_const:Nn \__gdut_professional_type
  {
    \clist_item:Nn \c__gdut_professional_clist
      { \g__gdut_thesis_type_int }
  }
%% 模板需要自定义的命令
% 西文日期
\DeclareExpandableDocumentCommand \engdate { +m } {
  \__english_date:www #1 \q_stop
}
\cs_new:Npn \__english_date:www #1/#2/#3 \q_stop {
  \ifcase #2 \or January~\or February~\or March~\or
  April~\or May ~\or June~\or July~\or August~\or September~\or October~\or November~\or
  December~\fi #3,~#1
}

% 封面日期
\DeclareExpandableDocumentCommand \coverdate { +m } {
  \__cover_date:www #1 \q_stop
}
\cs_new:Npn \__cover_date:www #1/#2/#3 \q_stop {
  \__cover_date_aux:nnn {#1} {#2} {#3}
}
\cs_new:Npn \__cover_date_aux:nnn {
  \__cover_date_aux:NNnnnn \zhnum_digits_null:n \zhnum_int:n { }
}
\cs_new:Npn \__cover_date_aux:NNnnnn #1#2#3#4#5#6
{
  #1 {#4} #3 \c__zhnum_year_tl #3
  #2 {#5} #3 \c__zhnum_month_tl #3
}
\cs_generate_variant:Nn \__cover_date_aux:nnn { V }
\clist_map_inline:nn
  {
    { ideo_comma       } { "3001 },
    { ideo_full_stop   } { "3002 },
    { fwid_comma       } { "FF0C },
    { fwid_full_stop   } { "FF0E },
    { fwid_colon       } { "FF1A },
    { fwid_semicolon   } { "FF1B },
    { fwid_left_paren  } { "FF08 },
    { fwid_right_paren } { "FF09 }
  }
  { \__gdut_define_punct:nn #1 }
% 独创性声明
\tl_const:Nn \c__gdut_orig_decl_text_tl
  {
    本人郑重声明：所呈交的学位论文是我个人在导师的指导下进行的研究工作
    及取得的研究成果。尽我所知，除了文中特别加以标注和致谢的地方外，论
    文中不包含其他人已经发表或撰写过的研究成果。与我一同工作的同志对本
    研究所做的任何贡献均已在论文中作了明确的说明，并表示了谢意。本人依
    法享有和承担由此论文所产生的权利和责任。
  }
\tl_const:Nn \c__gdut_auth_decl_text_tl
  {
    本学位论文作者完全了解学校有关保存、使用学位论文的规定：“研究生在
    广东工业大学学习和工作期间参与广东工业大学研究项目或承担广东工业大
    学安排的任务所完成的发明创造及其他技术成果，除另有协议外，归广东工
    业大学享有或特有”。同意授权广东工业大学保留并向国家有关部门或机构
    送交该论文的印刷本和电子版本，允许该论文被查阅和借阅。同意授权广东
    工业大学可以将本学位论文的全部或部分内容编入有关数据库进行检索，可
    以采用影印、缩印、扫描或数字化等其他复制手段保存和汇编本学位论文。
    保密论文在解密后遵守此规定。
  }
% 定义可更换的名称
\clist_const:Nn \c__gdut_thesis_type_clist
  { 博士学位, 硕士学位, 硕士专业学位 }
\clist_const:Nn \c__gdut_thesis_type_en_clist
  { Doctor, Master, Master }
\clist_const:Nn \c__gdut_secret_clist { 秘密, 机密, 绝密 }
\clist_const:Nn \c__gdut_professional_clist
  {一级学科（二级学科）名称, 一级学科（二级学科）名称, 专业学位类别（领域）名称}
\PassOptionsToClass
  {
    UTF8,
    fontset    = none,
    zihao      = -4,
    \g__gdut_to_ctexbook_clist
  }
  { ctexbook }
\clist_map_inline:nn
  {
    { no-math           } { fontspec },
    { titles            } { tocloft  },
    { UseMSWordMultipleLineSpacing, MSWordLineSpacingMultiple = 1.568 } { zhlineskip    },
    { firstpage = true, angle = 0, color = black, opacity = 1         } { background    },
    { warnings-off = { mathtools-colon, mathtools-overbracket }       } { unicode-math  },
  }
  { \PassOptionsToPackage #1 }
\LoadClass { ctexbook }
\@namedef{ver@everypage.sty}{9999/99/99}
\RequirePackage{silence}
\WarningFilter{zhlineskip}{Use Microsoft Word multiple line spacing}
\RequirePackage
  {
    amsmath,
    unicode-math,
    geometry,
    pdfpages,
    everypage-1x,
    background,
    fancyhdr,
    amsthm,
    thmtools,
    graphicx,
    longtable,
    caption,
    bicaption,
    xcolor,
    xeCJKfntef,
    xpatch,
    array,
    multirow,
    booktabs,
    calc,
    enumitem,
    tocloft,
    subfig,
    zhlineskip,
  }
%% 调整目录格式
% 纵向间距
\setlength{\cftbeforechapskip}{0pt}
\setlength{\cftbeforesecskip}{0pt}
\setlength{\cftbeforesubsecskip}{0pt}
% 缩进
\setlength{\cftsecindent}{2\ccwd}
\setlength{\cftsubsecindent}{4\ccwd}
% 设置字体
\renewcommand\cftchapfont{\sffamily}
\renewcommand\cftchapleader{\sffamily\cftdotfill{\cftchapdotsep}}
\renewcommand\cftchappagefont{\sffamily}
% 设置引导符
\renewcommand{\cftdot}{.}
\renewcommand\cftchapdotsep{\cftdotsep}
\renewcommand{\cftdotsep}{0}
% 设置引导符到页码的距离
\newlength{\yema}
\settowidth{\yema}{\cftchappagefont VII}
\cftsetpnumwidth{\yema}
% 设置计数器盒子的宽度
\setlength\cftchapnumwidth{3\ccwd}
\newlength{\secjuli}
\settowidth{\secjuli}{\cftsecfont 1.1}
\setlength\cftsecnumwidth{\secjuli}
\newlength{\subsecjuli}
\settowidth{\subsecjuli}{\cftsubsecfont 1.1.1}
\setlength\cftsubsecnumwidth{\subsecjuli}
%% 设置中西文列表
\newlist{gdutenum}{enumerate}{1}
\setlist[gdutenum,1]{leftmargin=0pt,labelsep=0pt,itemindent=2\ccwd+23.29015pt,parsep=0pt,itemsep=0pt,topsep=0pt,partopsep=0pt,listparindent=2\ccwd}
\renewcommand\thegdutenumi{\arabic{gdutenumi}}
\def\labelgdutenumi{（\thegdutenumi）}

\newlist{gdutenenum}{enumerate}{1}
\newlength{\enlabellengthi}
\setlength{\enlabellengthi}{0pt}
\setlist[gdutenenum,1]{leftmargin=0pt,labelsep=3pt,itemindent=2\ccwd+\the\enlabellengthi+3pt,parsep=0pt,itemsep=0pt,topsep=0pt,partopsep=0pt,listparindent=2\ccwd}
\def\setmythegdutenenumi#1{\setlength{\enlabellengthi}{\widthof{#1}}\def\labelgdutenenumi{#1}}
\renewcommand\thegdutenenumi{\arabic{gdutenenumi}}
\setmythegdutenenumi{(\thegdutenenumi)}


%% 设置目录中章后面的间距
\cs_set_protected:Npn \CTEX@toc@width@n #1
  {
    \hbox_set:Nn \l__ctex_tmp_box {#1\space}
    \dim_set:Nn \@tempdima
      {
        \box_wd:N \l__ctex_tmp_box
      }
  }
\xpatchcmd \tableofcontents
  {
    \chapter*{\contentsname
    \@mkboth{%
      \MakeUppercase\contentsname}{\MakeUppercase\contentsname}}
  }
  {
    \gdut_chapter { \contentsname }
  }
  {}{}
%% 定义双语目录
\def\en@toc@ext{tec}
\def\en@contentsname{CONTENTS}

%% two user commands
\newcommand\enTableOfContents{
  \begingroup
    % restore \contentsname
    \let\contentsname\en@contentsname
    % output en-toc
    \@enTableOfContents
  \endgroup
}

\newcommand\enSectionTitle[1]{
  \def\@currentTitle{#1}
  \ignorespaces
}

%% provide \@enTableOfContents
\cs_new_eq:NN \@enTableOfContents \tableofcontents
\@ifundefined {chapter}
  { % e.g., article.cls
    \xpatchcmd \@enTableOfContents
      {
        \@starttoc{toc}
      }
      {
        \endgroup
        \@starttoc{\en@toc@ext}
      }
      { } { \fail }
  }
  { % e.g., book.cls
    \xpatchcmd \@enTableOfContents
      {
        \gdut_chapter
      }
      {
        \begingroup
        \gdut_chapter
      }
      { } { \fail }
    \xpatchcmd \@enTableOfContents
      {
        \@starttoc{toc}
      }
      {
        \endgroup
        \@starttoc{\en@toc@ext}
      }
      { } { \fail }
  }

%% modify to write two toc entries
\cs_set_protected:Npn \CTEX@addtocline #1#2
  {
    % write cn-toc entry
    \addcontentsline { toc } {#1}
      { \use:c { CTEX@#1@tocline } {#1} {#2} }
    \begingroup
      \@ifundefined {chapter}
        {}
        {
          \ctexset{
            chapter/name   = {Chapter\ },
            chapter/number = \arabic{chapter},
          }
        }
      % write en-toc entry
      \addcontentsline \en@toc@ext {#1}
        { \use:c { CTEX@#1@tocline } {#1} { \@currentTitle } }
    \endgroup
  }

%% 设置章节格式
\setlength{\parskip}{0pt}
\renewcommand{\theparagraph}{\arabic{paragraph}.}
\renewcommand{\thesubparagraph}{(\arabic{subparagraph})}

\cs_new_protected:Npn \__gdut_check_package:nnn #1#2#3
  {
    \@ifpackagelater {#1} {#2}
      { } { \__gdut_error:nnn { package-too-old } { Package } {#1} {#3} }
  }
\cs_new_protected:Npn \__gdut_check_class:nnn #1#2#3
  {
    \@ifclasslater {#1} {#2}
      { } { \__gdut_error:nnnn { package-too-old } { Class } {#1} {#3} }
  }
\__gdut_msg_new:nn { package-too-old }
  {
    #1~ "#2"~ is~ too~ old. \\
    The~ gdutthesis~ class~ only~ supports~ "#2" \\
    with~ a~ version~ higher~ than~ v#3. \\\\
    Please~ update~ an~ up-to-date~ version~ of~ it \\
    using~ your~ TeX~ package~ manager~ or~ from~ CTAN.
  }
\__gdut_check_class:nnn   { ctexbook     } { 2017/08/07 } { 2.4.10 }
\__gdut_check_package:nnn { fontspec     } { 2017/09/22 } { 2.6e   }
\__gdut_check_package:nnn { unicode-math } { 2017/11/18 } { 0.8i   }
\sys_if_engine_xetex:T
  { \__gdut_check_package:nnn { xeCJK          } { 2017/08/07 } { 3.5.0 } }
\sys_if_engine_luatex:T
  { \__gdut_check_package:nnn { xunicode-addon } { 2018/04/30 } { 3.7.1 } }
%% 设置页面
\geometry{
  paper       = a4paper,
  margin      = 2.6cm,
  headheight  = 0.77cm,
  headsep     = 0.415cm,
  footskip    = 0.85cm,
}
\raggedbottom
\sloppy
\bool_if:NT \g__gdut_draft_bool { \geometry { showframe } }
\bool_new:N \l__gdut_cover_bool
\bool_new:N \l__gdut_open_bool
\keys_define:nn { gdut / style }
  {
    cover .choice:,
    cover .value_required:n = true,
    cover / true   .code:n =
      { \bool_set_true:N  \l__gdut_cover_bool },
    cover / false .code:n =
      { \bool_set_false:N \l__gdut_cover_bool },
    open  .choice:,
    open  .value_required:n = true,
    open  / true   .code:n =
      { \bool_set_true:N  \l__gdut_open_bool  },
    open  / false  .code:n =
      { \bool_set_false:N \l__gdut_open_bool  },
  }
\tl_new:N \g__gdut_fontset_tl
\tl_new:N \g__gdut_math_fontset_tl
\tl_new:N \g__gdut_cjk_fontset_tl
\keys_define:nn { gdut / style }
  {
    font .choices:nn =
      { garamond, libertinus, lm, palatino, times, times*, none }
      { \tl_set_eq:NN \g__gdut_fontset_tl \l_keys_choice_tl }
  }
\keys_define:nn { gdut / style }
  {
    math-font .choices:nn =
      { garamond, libertinus, lm, palatino, times, times*, none }
      { \tl_set_eq:NN \g__gdut_math_fontset_tl \l_keys_choice_tl }
  }
\keys_define:nn { gdut / style }
  {
    cjk-font .choices:nn =
      { fandol, founder, mac, sourcehan, noto, windows, none }
      { \tl_set_eq:NN \g__gdut_cjk_fontset_tl \l_keys_choice_tl }
  }
\cs_new_protected:Npn \__gdut_setmainfont:nn #1#2
  { \__fontspec_main_setmainfont:nn {#2} {#1} }
\cs_new_protected:Npn \__gdut_setsansfont:nn #1#2
  { \__fontspec_main_setsansfont:nn {#2} {#1} }
\cs_new_protected:Npn \__gdut_setmonofont:nn #1#2
  { \__fontspec_main_setmonofont:nn {#2} {#1} }
\cs_new_protected:Npn \__gdut_setmathfont:nn #1#2
  { \__um_setmathfont:nn {#2} {#1} }
\cs_new_protected:Npn \__gdut_setCJKmainfont:nn #1#2
  { \__gdut_set_family:xnn { \CJKrmdefault } {#2} {#1} }
\cs_new_protected:Npn \__gdut_setCJKsansfont:nn #1#2
  { \__gdut_set_family:xnn { \CJKsfdefault } {#2} {#1} }
\cs_new_protected:Npn \__gdut_setCJKmonofont:nn #1#2
  { \__gdut_set_family:xnn { \CJKttdefault } {#2} {#1} }
\cs_new_protected:Npn \__gdut_set_cjk_font_kai:nn #1#2
  { \__gdut_set_family:nnn { gdut@kai } {#2} {#1} \newfontfamily \gdutenkai {#1} }
\cs_new_protected:Npn \gdut@kai
  { \__gdut_switch_family:n { gdut@kai } }
\tl_const:Nn \__gdut_cjk_font_options:
 { UprightFont = *, ItalicFont = *, AutoFakeBold = true }
\cs_new_protected:Npx \__gdut_setCJKmainfont:n   #1
  { \__gdut_setCJKmainfont:nn   {#1} { \__gdut_cjk_font_options: } }
\cs_new_protected:Npx \__gdut_setCJKsansfont:n   #1
  { \__gdut_setCJKsansfont:nn   {#1} { \__gdut_cjk_font_options: } }
\cs_new_protected:Npx \__gdut_setCJKmonofont:n   #1
  { \__gdut_setCJKmonofont:nn   {#1} { \__gdut_cjk_font_options: } }
\cs_new_protected:Npx \__gdut_set_cjk_font_kai:n #1
  { \__gdut_set_cjk_font_kai:nn {#1} { \__gdut_cjk_font_options: } }
\sys_if_engine_xetex:TF
  {
    \cs_new_eq:NN \__gdut_set_family:nnn  \xeCJK_set_family:nnn
    \cs_new_eq:NN \__gdut_switch_family:n \xeCJK_switch_family:n
  }
  {
    \cs_new_eq:NN \__gdut_set_family:nnn  \ctex_ltj_set_family:nnn
    \cs_new_eq:NN \__gdut_switch_family:n \ctex_ltj_switch_family:n
  }
\cs_generate_variant:Nn \__gdut_set_family:nnn { x }
\cs_new_protected:Npn \__gdut_set_font_helper:n #1
  {
    \exp_args:Nc \RenewDocumentCommand { set #1 font } { O { } m O { } }
      {
        \ctex_at_end_preamble:n
          { \use:c { __gdut_set #1 font:nn } {##2} { ##1, ##3 } }
      }
  }
\clist_map_inline:nn { main, sans, mono, math    } { \__gdut_set_font_helper:n {#1} }
\clist_map_inline:nn { CJKmain, CJKsans, CJKmono } { \__gdut_set_font_helper:n {#1} }
\tl_new:N \g__gdut_font_family_libertinus_serif_tl
\tl_new:N \g__gdut_font_family_libertinus_sans_tl
\tl_new:N \g__gdut_font_style_libertinus_rm_tl
\tl_new:N \g__gdut_font_style_libertinus_bf_tl
\tl_new:N \g__gdut_font_style_libertinus_it_tl
\tl_new:N \g__gdut_font_style_libertinus_bfit_tl
\tl_new:N \g__gdut_font_style_libertinus_bfsl_tl
\tl_new:N \g__gdut_font_family_xits_tl
\tl_new:N \g__gdut_font_style_xits_rm_tl
\tl_new:N \g__gdut_font_style_xits_bf_tl
\tl_new:N \g__gdut_font_style_xits_it_tl
\tl_new:N \g__gdut_font_style_xits_bfit_tl
\tl_new:N \g__gdut_font_name_libertinus_serif_tl
\tl_new:N \g__gdut_font_name_libertinus_sans_tl
\tl_new:N \g__gdut_font_name_libertinus_math_tl
\tl_new:N \g__gdut_font_name_xits_tl
\tl_new:N \g__gdut_font_name_xits_math_rm_tl
\tl_new:N \g__gdut_font_name_xits_math_bf_tl
\fontspec_font_if_exist:nTF { LibertinusSerif-Regular.otf }
  {
    \tl_set:Nn \g__gdut_font_family_libertinus_serif_tl { LibertinusSerif }
    \tl_set:Nn \g__gdut_font_family_libertinus_sans_tl  { LibertinusSans  }
    \tl_set:Nn \g__gdut_font_family_libertinus_math_tl  { LibertinusMath  }
    \tl_set:Nn \g__gdut_font_style_libertinus_rm_tl     { Regular         }
    \tl_set:Nn \g__gdut_font_style_libertinus_bf_tl     { Bold            }
    \tl_set:Nn \g__gdut_font_style_libertinus_it_tl     { Italic          }
    \tl_set:Nn \g__gdut_font_style_libertinus_bfit_tl   { BoldItalic      }
    \tl_set:Nn \g__gdut_font_style_libertinus_bfsl_tl   { BoldOblique     }
  }
  {
    \tl_set:Nn \g__gdut_font_family_libertinus_serif_tl { libertinusserif }
    \tl_set:Nn \g__gdut_font_family_libertinus_sans_tl  { libertinussans  }
    \tl_set:Nn \g__gdut_font_family_libertinus_math_tl  { libertinusmath  }
    \tl_set:Nn \g__gdut_font_style_libertinus_rm_tl     { regular         }
    \tl_set:Nn \g__gdut_font_style_libertinus_bf_tl     { bold            }
    \tl_set:Nn \g__gdut_font_style_libertinus_it_tl     { italic          }
    \tl_set:Nn \g__gdut_font_style_libertinus_bfit_tl   { bolditalic      }
    \tl_set:Nn \g__gdut_font_style_libertinus_bfsl_tl   { bolditalic      }
  }
\fontspec_font_if_exist:nTF { XITS-Regular.otf }
  {
    \tl_set:Nn \g__gdut_font_family_xits_tl        { XITS             }
    \tl_set:Nn \g__gdut_font_style_xits_rm_tl      { Regular          }
    \tl_set:Nn \g__gdut_font_style_xits_bf_tl      { Bold             }
    \tl_set:Nn \g__gdut_font_style_xits_it_tl      { Italic           }
    \tl_set:Nn \g__gdut_font_style_xits_bfit_tl    { BoldItalic       }
    \tl_set:Nn \g__gdut_font_name_xits_math_rm_tl  { XITSMath-Regular }
    \tl_set:Nn \g__gdut_font_name_xits_math_bf_tl  { XITSMath-Bold    }
  }
  {
    \tl_set:Nn \g__gdut_font_family_xits_tl        { xits          }
    \tl_set:Nn \g__gdut_font_style_xits_rm_tl      { regular       }
    \tl_set:Nn \g__gdut_font_style_xits_bf_tl      { bold          }
    \tl_set:Nn \g__gdut_font_style_xits_it_tl      { italic        }
    \tl_set:Nn \g__gdut_font_style_xits_bfit_tl    { bolditalic    }
    \tl_set:Nn \g__gdut_font_name_xits_math_rm_tl  { xits-math     }
    \tl_set:Nn \g__gdut_font_name_xits_math_bf_tl  { xits-mathbold }
  }
\tl_set:Nx \g__gdut_font_name_libertinus_serif_tl
  { \g__gdut_font_family_libertinus_serif_tl - \g__gdut_font_style_libertinus_rm_tl }
\tl_set:Nx \g__gdut_font_name_libertinus_sans_tl
  { \g__gdut_font_family_libertinus_sans_tl  - \g__gdut_font_style_libertinus_rm_tl }
\tl_set:Nx \g__gdut_font_name_libertinus_math_tl
  { \g__gdut_font_family_libertinus_math_tl  - \g__gdut_font_style_libertinus_rm_tl }
\tl_set:Nx \g__gdut_font_name_xits_tl
  { \g__gdut_font_family_xits_tl - \g__gdut_font_style_xits_rm_tl }
\cs_new_protected:Npn \__gdut_load_font_garamond:
  {
    \__gdut_setmainfont:nn { EBGaramond }
      {
        Extension      = .otf,
        UprightFont    = *-Regular,
        BoldFont       = *-Bold,
        ItalicFont     = *-Italic,
        BoldItalicFont = *-BoldItalic
      }
    \__gdut_setsansfont:nn { \g__gdut_font_family_libertinus_sans_tl }
      {
        Extension      = .otf,
        UprightFont    = *-\g__gdut_font_style_libertinus_rm_tl,
        BoldFont       = *-\g__gdut_font_style_libertinus_bf_tl,
        ItalicFont     = *-\g__gdut_font_style_libertinus_it_tl,
        BoldItalicFont = *-\g__gdut_font_style_libertinus_bf_tl
      }
    \__gdut_setmonofont:nn { lmmonolt10 }
      {
        Extension      = .otf,
        UprightFont    = *-regular,
        BoldFont       = *-bold,
        ItalicFont     = *-oblique,
        BoldItalicFont = *-boldoblique
      }
  }
\cs_new_protected:Npn \__gdut_load_font_libertinus:
  {
    \__gdut_setmainfont:nn { \g__gdut_font_family_libertinus_serif_tl }
      {
        Extension      = .otf,
        UprightFont    = *-\g__gdut_font_style_libertinus_rm_tl,
        BoldFont       = *-\g__gdut_font_style_libertinus_bf_tl,
        ItalicFont     = *-\g__gdut_font_style_libertinus_it_tl,
        BoldItalicFont = *-\g__gdut_font_style_libertinus_bfit_tl
      }
    \__gdut_setsansfont:nn { \g__gdut_font_family_libertinus_sans_tl }
      {
        Extension      = .otf,
        UprightFont    = *-\g__gdut_font_style_libertinus_rm_tl,
        BoldFont       = *-\g__gdut_font_style_libertinus_bf_tl,
        ItalicFont     = *-\g__gdut_font_style_libertinus_it_tl,
        BoldItalicFont = *-\g__gdut_font_style_libertinus_bf_tl
      }
    \__gdut_setmonofont:nn { lmmonolt10 }
      {
        Extension      = .otf,
        UprightFont    = *-regular,
        BoldFont       = *-bold,
        ItalicFont     = *-oblique,
        BoldItalicFont = *-boldoblique
      }
  }
\cs_new_protected:Npn \__gdut_load_font_lm:
  {  }
\cs_new_protected:Npn \__gdut_load_font_palatino:
  {
    \__gdut_setmainfont:nn { texgyrepagella }
      {
        Extension      = .otf,
        UprightFont    = *-regular,
        BoldFont       = *-bold,
        ItalicFont     = *-italic,
        BoldItalicFont = *-bolditalic
      }
    \__gdut_setsansfont:nn { \g__gdut_font_family_libertinus_sans_tl }
      {
        Extension      = .otf,
        UprightFont    = *-\g__gdut_font_style_libertinus_rm_tl,
        BoldFont       = *-\g__gdut_font_style_libertinus_bf_tl,
        ItalicFont     = *-\g__gdut_font_style_libertinus_it_tl,
        BoldItalicFont = *-\g__gdut_font_style_libertinus_bf_tl,
        Scale          = MatchUppercase
      }
    \__gdut_setmonofont:nn { lmmonolt10 }
      {
        Extension      = .otf,
        UprightFont    = *-regular,
        BoldFont       = *-bold,
        ItalicFont     = *-oblique,
        BoldItalicFont = *-boldoblique
      }
  }
\cs_new_protected:Npn \__gdut_load_font_times:
  {
    \__gdut_setmainfont:nn { \g__gdut_font_family_xits_tl }
      {
        Extension          = .otf,
        UprightFont        = *-\g__gdut_font_style_xits_rm_tl,
        BoldFont           = *-\g__gdut_font_style_xits_bf_tl,
        ItalicFont         = *-\g__gdut_font_style_xits_it_tl,
        BoldItalicFont     = *-\g__gdut_font_style_xits_bfit_tl
      }
    \__gdut_setsansfont:nn { texgyreheros }
      {
        Extension      = .otf,
        UprightFont    = *-regular,
        BoldFont       = *-bold,
        ItalicFont     = *-italic,
        BoldItalicFont = *-bolditalic
      }
    \__gdut_setmonofont:nn { texgyrecursor }
      {
        Extension      = .otf,
        UprightFont    = *-regular,
        BoldFont       = *-bold,
        ItalicFont     = *-italic,
        BoldItalicFont = *-bolditalic,
        Ligatures      = CommonOff
      }
  }
\cs_new_protected:cpn { __gdut_load_font_ times* : }
  {
    \__gdut_setmainfont:nn { Times~ New~ Roman    } { }
    \__gdut_setsansfont:nn { Arial                } { }
    \__gdut_setmonofont:nn { Courier~ New         } { }
  }
\cs_new_protected:Npn \__gdut_load_math_font_garamond:
  {
    \__gdut_setmathfont:nn { Garamond-Math.otf } { }
  }
\cs_new_protected:Npn \__gdut_load_math_font_libertinus:
  {
    \__gdut_setmathfont:nn { \g__gdut_font_name_libertinus_math_tl .otf } { }
  }
\cs_new_protected:Npn \__gdut_load_math_font_lm:
  { \__gdut_setmathfont:nn { latinmodern-math.otf } { } }
\cs_new_protected:Npn \__gdut_load_math_font_palatino:
  {
    \__gdut_setmathfont:nn { texgyrepagella-math.otf } { }
  }
\cs_new_protected:Npn \__gdut_load_math_font_times:
  {
    \__gdut_setmathfont:nn { \g__gdut_font_name_xits_math_rm_tl .otf }
      { BoldFont = \g__gdut_font_name_xits_math_bf_tl .otf }
  }
\cs_new_protected:cpn { __gdut_load_math_font_ times* : }
  {
    \__gdut_setmathfont:nn { \g__gdut_font_name_xits_math_rm_tl .otf }
      { BoldFont = \g__gdut_font_name_xits_math_bf_tl .otf }
  }
\cs_new_protected:Npn \__gdut_load_cjk_font_fandol:
  {
    \__gdut_setCJKmainfont:nn   { FandolSong }
      {
        Extension      = .otf,
        UprightFont    = *-Regular,
        BoldFont       = *-Bold,
        ItalicFont     = *-Regular,
        BoldItalicFont = *-Bold
      }
    \__gdut_setCJKsansfont:nn   { FandolHei  }
      {
        Extension      = .otf,
        UprightFont    = *-Regular,
        BoldFont       = *-Bold,
        ItalicFont     = *-Regular,
        BoldItalicFont = *-Bold
      }
    \__gdut_setCJKmonofont:nn   { FandolFang }
      {
        Extension      = .otf,
        UprightFont    = *-Regular,
        BoldFont       = *-Regular,
        ItalicFont     = *-Regular,
        BoldItalicFont = *-Regular
      }
    \__gdut_set_cjk_font_kai:nn { FandolKai  }
      {
        Extension      = .otf,
        UprightFont    = *-Regular,
        BoldFont       = *-Regular,
        ItalicFont     = *-Regular,
        BoldItalicFont = *-Regular
      }
  }
\cs_new_protected:Npn \__gdut_load_cjk_font_founder:
  {
    \__gdut_setCJKmainfont:n   { FZShuSong-Z01  }
    \__gdut_setCJKsansfont:n   { FZHei-B01      }
    \__gdut_setCJKmonofont:n   { FZFangSong-Z02 }
    \__gdut_set_cjk_font_kai:n { FZKai-Z03      }
  }
\cs_new_protected:Npn \__gdut_load_cjk_font_mac:
  {
    \__gdut_setCJKmainfont:nn   { STSongti-SC }
      {
        UprightFont    = *-Light,
        BoldFont       = *-Bold,
        ItalicFont     = *-Light,
        BoldItalicFont = *-Bold
      }
    \__gdut_setCJKsansfont:nn   { STHeitiSC   }
      {
        UprightFont    = *-Medium,
        AutoFakeBold   = true,
        ItalicFont     = *-Medium,
        BoldItalicFont = *-Medium
      }
    \__gdut_setCJKmonofont:n    { STFangsong  }
    \__gdut_set_cjk_font_kai:nn { STKaitiSC   }
      {
        UprightFont    = *-Regular,
        BoldFont       = *-Bold,
        ItalicFont     = *-Regular,
        BoldItalicFont = *-Bold
      }
  }
\cs_new_protected:Npn \__gdut_load_cjk_font_sourcehan:
  {
    \__gdut_setCJKmainfont:nn { Source~Han~Serif~SC }
      {
        UprightFont    = *-Regular,
        BoldFont       = *-Bold,
        ItalicFont     = *-Regular,
        BoldItalicFont = *-Bold
      }
    \__gdut_setCJKsansfont:nn { Source~Han~Sans~SC  }
      {
        UprightFont    = *-Regular,
        BoldFont       = *-Bold,
        ItalicFont     = *-Regular,
        BoldItalicFont = *-Bold
      }
    \__gdut_setCJKmonofont:nn   { FandolFang }
      {
        Extension      = .otf,
        UprightFont    = *-Regular,
        BoldFont       = *-Regular,
        ItalicFont     = *-Regular,
        BoldItalicFont = *-Regular
      }
    \__gdut_set_cjk_font_kai:nn { FandolKai  }
      {
        Extension      = .otf,
        UprightFont    = *-Regular,
        BoldFont       = *-Regular,
        ItalicFont     = *-Regular,
        BoldItalicFont = *-Regular
      }
  }
\cs_new_protected:Npn \__gdut_load_cjk_font_noto:
  {
    \__gdut_setCJKmainfont:nn { Noto~Serif~CJK~SC }
      {
        UprightFont    = *-Regular,
        BoldFont       = *-Bold,
        ItalicFont     = *-Regular,
        BoldItalicFont = *-Bold
      }
    \__gdut_setCJKsansfont:nn { Noto~Sans~CJK~SC  }
      {
        UprightFont    = *-Regular,
        BoldFont       = *-Bold,
        ItalicFont     = *-Regular,
        BoldItalicFont = *-Bold
      }
    \__gdut_setCJKmonofont:nn { Noto~Sans~Mono~CJK~SC }
      {
        UprightFont    = *-Regular,
        BoldFont       = *-Bold,
        ItalicFont     = *-Regular,
        BoldItalicFont = *-Bold
      }
    \__gdut_set_cjk_font_kai:nn { FandolKai  }
      {
        Extension      = .otf,
        UprightFont    = *-Regular,
        BoldFont       = *-Regular,
        ItalicFont     = *-Regular,
        BoldItalicFont = *-Regular
      }
  }
\cs_new_protected:Npn \__gdut_load_cjk_font_windows:
  {
    \__gdut_setCJKmainfont:n   { SimSun   }
    \__gdut_setCJKsansfont:n   { SimHei   }
    \__gdut_setCJKmonofont:n   { FangSong }
    \__gdut_set_cjk_font_kai:n { KaiTi    }
  }
\cs_new_protected:Npn \__gdut_load_font:
  {
    \use:c { __gdut_load_font_      \g__gdut_fontset_tl       : }
    \use:c { __gdut_load_math_font_ \g__gdut_math_fontset_tl  : }
    \use:c { __gdut_load_cjk_font_  \g__gdut_cjk_fontset_tl   : }
  }
\ctex_at_end_preamble:n { \__gdut_load_font: }
\keys_set:nn { unicode-math }
  {
    math-style = ISO,
    bold-style = ISO,
  }
\keys_define:nn { gdut / style }
  {
    fullwidth-stop .choice:,
    fullwidth-stop .value_required:n = true,
    fullwidth-stop / catcode .code:n =
      { \__gdut_set_fullwidth_stop_catcode: },
    fullwidth-stop / mapping .code:n =
      {
        \sys_if_engine_xetex:TF
          {
            \clist_gset:Nn \g__xeCJK_default_features_clist
              { Mapping = fullwidth-stop }
          }
          {
            \sys_if_engine_luatex:T
              {
                \__gdut_warning:n { mapping-not-available }
                \__gdut_set_fullwidth_stop_catcode:
              }
          }
      },
    fullwidth-stop / false .code:n = { }
  }
\__gdut_msg_new:nn { mapping-not-available }
  {
    Option~ "fullwidth-stop = mapping"~ is~ not~ available~ in~ LuaTeX. \\
    "fullwidth-stop = catcode"~ will~ be~ set~ instead.
  }
\cs_new:Npn \__gdut_set_fullwidth_stop_catcode:
  {
    \char_set_active_eq:nN { "3002 } \c__gdut_fwid_full_stop_tl
    \char_set_catcode_active:n { "3002 }
  }
\DeclareEmphSequence
  {
    \itshape \gdut@kai,
    \upshape \CJKfamily { \CJKfamilydefault },
  }
%% 设置页眉页脚
\fancyhf{}
\fancyfoot[C]{\zihao{-5}\thepage}
\fancyhead[CO]{\zihao{-5}\gdut@kai\gdutenkai \leftmark}
\fancyhead[CE]{\zihao{-5}\gdut@kai\gdutenkai 广东工业大学 \__gdut_thesis_type 论文}
\renewcommand{\headrulewidth}{1.5pt}
\renewcommand{\headruleskip}{6.2pt}
\newcommand{\myheadrulewidth}{0.8pt}
  \def\headrule{{\if@fancyplain\let\headrulewidth\plainheadrulewidth\fi
      \hrule\@height\headrulewidth\@width\headwidth
      \vskip0.75pt
      \hrule\@height\myheadrulewidth\@width\headwidth
      \vskip-\headrulewidth\vskip-\myheadrulewidth
      }}%
\renewcommand{\footrulewidth}{0pt}
\xpatchcmd
  { \chaptermark   }
  { \MakeUppercase }
  { \relax }
  { } { }
\pagestyle { fancy }
%% 设置章节格式
\keys_set:nn { ctex }
{
  secnumdepth=5,
  chapter = {
    format      = \zihao{-2}\sffamily\centering,
    pagestyle   = fancy,
    aftername   = \hspace{\ccwd},
    beforeskip  = 0pt,
    afterskip   = 1.5\baselineskip-1.5\ccwd,
    fixskip     = true,
    tocline     = \CTEXnumberline{#1}#2,
  },
  section = {
    format      = \zihao{-3}\sffamily\raggedright,
    aftername   = {~},
    beforeskip  = 1.25\baselineskip-1.25\ccwd,
    afterskip   = 1.25\baselineskip-1.25\ccwd,
    fixskip     = true,
  },
  subsection = {
    format      = \zihao{4}\sffamily\raggedright,
    aftername   = {~},
    beforeskip  = 1.167\baselineskip-1.167\ccwd,
    afterskip   = 1.167\baselineskip-1.167\ccwd,
    fixskip     = true,
  },
  subsubsection = {
    runin       = true,
    format      = \zihao{-4}\sffamily\raggedright,
    aftername   = {~},
    beforeskip  = \baselineskip-\ccwd,
    afterskip   = \ccwd,
    aftertitle  = {},
    fixskip     = true,
  },
  paragraph = {
    format      = \zihao{-4}\sffamily\raggedright,
    indent      = 2\ccwd,
    aftername   = {~},
    beforeskip  = \baselineskip-\ccwd,
    afterskip   = 0pt,
    fixskip     = true,
  },
  subparagraph = {
    format      = \zihao{-4}\sffamily\raggedright,
    indent      = 2\ccwd,
    aftername   = {~},
    beforeskip  = \baselineskip-\ccwd,
    afterskip   = 0pt,
    fixskip     = true,
  },
}
\ctex_at_end_preamble:n
{
  \bool_if:NTF \l__gdut_open_bool
  {
    \keys_set:nn { ctex }
    {
      chapter / break =
      {
        \clearpage
      }
    }
    \xpatchcmd { \mainmatter }
    {
      \cleardoublepage
    }
    {
      \clearpage
    }
    { } { \fail }
  }
  { }
}
\tl_new:N   \l__gdut_thm_header_font_tl
\tl_new:N   \l__gdut_thm_body_font_tl
\tl_new:N   \l__gdut_thm_qed_tl
\tl_new:N   \l__gdut_thm_punct_tl
\tl_new:N   \l__gdut_thm_left_braces_tl
\tl_new:N   \l__gdut_thm_right_braces_tl
\tl_new:N   \gdut@interval
\dim_new:N  \l__gdut_indent_dim
\keys_define:nn { gdut / theorem }
  {
    header-font .choice:,
    header-font .value_required:n = true,
    header-font / bf .code:n =
      { \cs_set_eq:NN \l__gdut_thm_header_font_tl \bfseries },
    header-font / sf .code:n =
      { \cs_set_eq:NN \l__gdut_thm_header_font_tl \sffamily },
    body-font .choice:,
    body-font .value_required:n = true,
    body-font / rm  .code:n =
      { \cs_set_eq:NN \l__gdut_thm_body_font_tl \normalfont },
    body-font / kai .code:n =
      { \cs_set_eq:NN \l__gdut_thm_body_font_tl \gdut@kai   },
    indent .choice:,
    indent .value_required:n = true,
    indent / en .code:n =
      { \dim_set:Nn \l__gdut_indent_dim {0pt}     },
    indent / cn .code:n =
      { \dim_set:Nn \l__gdut_indent_dim {2\ccwd}  },
    interval .choice:,
    interval .value_required:n = true,
    interval / dot  .code:n =
      { \cs_set_eq:NN \gdut@interval .  },
    interval / dash .code:n =
      { \cs_set_eq:NN \gdut@interval -  },
    punct .choice:,
    punct .value_required:n = true,
    punct / colon .code:n =
      { \cs_set_eq:NN \l__gdut_thm_punct_tl ：      },
    punct / quad  .code:n =
      { \cs_set_eq:NN \l__gdut_thm_punct_tl \quad   },
    braces .choice:,
    braces .value_required:n = true,
    braces / paren    .code:n =
      {
        \cs_set_eq:NN \l__gdut_thm_left_braces_tl   （
        \cs_set_eq:NN \l__gdut_thm_right_braces_tl  ）
      },
    braces / bracket  .code:n =
      {
        \cs_set_eq:NN \l__gdut_thm_left_braces_tl   【
        \cs_set_eq:NN \l__gdut_thm_right_braces_tl  】
      },
    qed .tl_set:N = \l__gdut_thm_qed_tl,
  }
\RenewDocumentCommand \newtheorem { s m m }
  {
    \IfBooleanTF {#1}
      {
        \declaretheorem[style=gdut-no-number,name=#3,refname={#3},Refname={#3}]{#2}
      }
      {
        \declaretheorem[style=gdut-number,name=#3,refname={#3},Refname={#3}]{#2}
        \tl_set:cn{the #2}{\thechapter \gdut@interval \arabic{#2}}
      }
  }
\ctex_at_end_preamble:n
  {
    \declaretheoremstyle[
      spaceabove    = 0pt,
      spacebelow    = 0pt,
      postheadspace = 0pt,
      numberwithin  = chapter,
      headpunct     = {\l__gdut_thm_punct_tl},
      headfont      = \l__gdut_thm_header_font_tl,
      notefont      = \l__gdut_thm_header_font_tl,
      notebraces    = {\l__gdut_thm_left_braces_tl}{\l__gdut_thm_right_braces_tl},
      bodyfont      = \l__gdut_thm_body_font_tl,
      qed           = \l__gdut_thm_qed_tl,
      headindent    = \l__gdut_indent_dim,
      numbered      = no,
    ]{gdut-no-number}
    \declaretheoremstyle[
      spaceabove    = 0pt,
      spacebelow    = 0pt,
      postheadspace = 0pt,
      numberwithin  = chapter,
      headpunct     = {\l__gdut_thm_punct_tl},
      headfont      = \l__gdut_thm_header_font_tl,
      notefont      = \l__gdut_thm_header_font_tl,
      notebraces    = {\l__gdut_thm_left_braces_tl}{\l__gdut_thm_right_braces_tl},
      bodyfont      = \l__gdut_thm_body_font_tl,
      qed           = ,
      headindent    = \l__gdut_indent_dim,
    ]{gdut-number}
    \cs_undefine:N \proof
    \cs_undefine:N \endproof
    \newtheorem { assertion   } {  断言 }
    \newtheorem { assumption  } {  假设 }
    \newtheorem { axiom       } {  公理 }
    \newtheorem { corollary   } {  推论 }
    \newtheorem { definition  } {  定义 }
    \newtheorem { example     } {  例   }
    \newtheorem { lemma       } {  引理 }
    \newtheorem*{ proof       } {  证明 }
    \newtheorem { proposition } {  命题 }
    \newtheorem*{ remark      } {  注   }
    \newtheorem { theorem     } {  定理 }
  }

%% 设置图表格式
\DeclareCaptionLabelFormat{english}{#1~#2}
\captionsetup
  {
    labelsep      = space,
    labelformat   = english,
    font          = small,
    labelfont     = bf,
    justification = centering
  }
\captionsetup[figure][bi-second]{name=Figure}
\captionsetup[table][bi-second]{name=Table}
\captionsetup[subfloat]
  {
    labelformat = simple,
    font        = small,
    labelfont   = md,
    captionskip = 4pt,
    nearskip    = -5pt,
    farskip     = 0pt
  }
\cs_set:Npn\thesubfigure{(\alph{subfigure})}
\cs_set:Npn\thetable{\thechapter-\arabic{table}}
\cs_set:Npn\thefigure{\thechapter-\arabic{figure}}
%% 设置引用格式
\labelformat{ equation } { (#1) }
\clist_map_inline:nn
  {
    { subfigure , 图    },
    { figure    , 图    },
    { table     , 表    },
    { equation  , 公式  },
    { appendix  , 附录  },
  }
  {
    \cs_new:cpn { \clist_item:nn {#1} {1} autorefname } { \clist_item:nn {#1} {2} }
  }
%% 设置浮动体间距
\setlength{\floatsep}{2\baselineskip-2\ccwd-1pt}
\setlength{\textfloatsep}{2\baselineskip-2\ccwd-1pt}
\setlength{\intextsep}{2\baselineskip-2\ccwd-1pt}
\ctex_patch_cmd:Nnn \@addtocurcol
  {\vskip \intextsep}
  {\edef\save@first@penalty{\the\lastpenalty}\unpenalty
   \ifnum \lastpenalty = \@M  % hopefully the OR penalty
     \unpenalty
   \else
     \penalty \save@first@penalty \relax % put it back
   \fi
   \ifnum\outputpenalty <-\@Mii
     \addvspace\intextsep
     \vskip\parskip
   \else
     \addvspace\intextsep
   \fi}
\ctex_patch_cmd:Nnn \@addtocurcol
  {\vskip\intextsep \ifnum\outputpenalty <-\@Mii \vskip -\parskip\fi}
  {\ifnum\outputpenalty <-\@Mii
     \aftergroup\vskip\aftergroup\intextsep
     \aftergroup\nointerlineskip
   \else
     \vskip\intextsep
   \fi}
\ctex_patch_cmd:Nnn \@getpen { \@M } { \@Mi }
%% 设置浮动体格式
\AtBeginEnvironment{figure}{%
  \def\@floatboxreset{\centering}%
}
\AtBeginEnvironment{table}{%
  \def\@floatboxreset{\centering}%
}
\AtBeginEnvironment{table}{\small}
\clist_map_inline:nn
  {
    title, date, author, degree, supervisor, supervisor_two, department, major, student_id, chairman,
  }
  {
    \tl_new:c { l__gdut_info_ #1 _tl }
  }
\clist_new:N \l__gdut_info_keywords_clist
\clist_map_inline:nn
  {
    supervisor, supervisor_two, supervisor-three
  }
  {
    \tl_new:c { l__gdut_info_ #1 _name_tl }
  }
\clist_map_inline:nn
  {
    supervisor, supervisor_two, supervisor-three
  }
  {
    \tl_new:c { l__gdut_info_ #1 _jobtitle_tl }
  }
\clist_map_inline:nn
  { title, author, degree, supervisor, supervisor_two, department }
  {
    \tl_new:c { l__gdut_info_ #1 _en_tl }
  }
\clist_new:N \l__gdut_info_keywords_en_clist
\keys_define:nn { gdut / info }
  {
    title             .tl_set:N    = \l__gdut_info_title_tl,
    title*            .tl_set:N    = \l__gdut_info_title_en_tl,
    date              .tl_set:N    = \l__gdut_info_date_tl,
    author            .tl_set:N    = \l__gdut_info_author_tl,
    author*           .tl_set:N    = \l__gdut_info_author_en_tl,
    degree            .tl_set:N    = \l__gdut_info_degree_tl,
    degree*           .tl_set:N    = \l__gdut_info_degree_en_tl,
    supervisor        .clist_set:N = \l__gdut_info_supervisor_tl,
    supervisor*       .tl_set:N    = \l__gdut_info_supervisor_en_tl,
    supervisor-two    .clist_set:N = \l__gdut_info_supervisor_two_tl,
    supervisor-two*   .tl_set:N    = \l__gdut_info_supervisor_two_en_tl,
    supervisor-three  .clist_set:N = \l__gdut_info_supervisor_three_tl,
    supervisor-three* .tl_set:N    = \l__gdut_info_supervisor_three_en_tl,
    department        .tl_set:N    = \l__gdut_info_department_tl,
    department*       .tl_set:N    = \l__gdut_info_department_en_tl,
    major             .tl_set:N    = \l__gdut_info_major_tl,
    student-id        .tl_set:N    = \l__gdut_info_student_id_tl,
    keywords          .clist_set:N = \l__gdut_info_keywords_clist,
    keywords*         .clist_set:N = \l__gdut_info_keywords_en_clist,
    chairman          .tl_set:N    = \l__gdut_info_chairman_clist,
  }
\clist_map_inline:nn
  {
    supervisor, supervisor_two, supervisor_three
  }
  {
    \tl_set:cn { l__gdut_info_ #1 _name_tl }
      {
        \clist_item:cn { l__gdut_info_ #1 _tl }
          { 1 }
      }
    \tl_set:cn { l__gdut_info_ #1 _jobname_tl }
      {
        \clist_item:cn { l__gdut_info_ #1 _tl }
          { 2 }
      }
  }
\bool_new:N \l__gdut_secret_bool
\tl_new:N \l__gdut_info_secret_level_tl
\keys_define:nn { gdut / info }
  {
    secret-level .choices:nn  =
      { none, i, ii, iii }
      {
        \int_compare:nTF { \l_keys_choice_int >= 2 }
          {
            \bool_set_true:N \l__gdut_secret_bool
            \tl_set:Nn \l__gdut_info_secret_level_tl
              {
                \clist_item:Nn \c__gdut_secret_clist
                  { \l_keys_choice_int - 1 }
              }
          }
          { \bool_set_false:N \l__gdut_secret_bool }
      },
    secret-level .value_required:n = true,
  }
%% 设置数学间距
\ctex_after_end_preamble:n
  {
    \setlength{\abovedisplayskip}{0.5\baselineskip - 0.5\ccwd}
    \setlength{\belowdisplayskip}{0pt}
    \setlength{\abovedisplayshortskip}{0pt}
    \setlength{\belowdisplayshortskip}{0.5\baselineskip - 0.5\ccwd}
  }
%% 输出封面
\ctex_after_end_preamble:n
  {
    \gdutmaketitle
  }
%% 定义双语章节
\cs_new_protected:Npn \__gdut_backup_chapter_helper:n #1
  {
    \cs_new_eq:cc { gdut_ #1 } { #1 }
  }
\clist_map_inline:nn { chapter, section, subsection    } { \__gdut_backup_chapter_helper:n {#1} }
\cs_new_protected:Npn \__gdut_set_chapter_helper:n #1
  {
    \exp_args:Nc \RenewDocumentCommand { #1 } { m m }
      {
        \enSectionTitle { ##2 }
        \use:c { gdut_ #1 } { ##1 }
      }
    \cs_new_eq:cc { gdut #1 } { #1 }
  }
\clist_map_inline:nn { chapter, section, subsection    } { \__gdut_set_chapter_helper:n {#1} }
\NewDocumentCommand \gdutbackmatter { }
  {
    \ctexset{ chapter/numbering = false }
  }
\NewDocumentCommand \gdutbacksection { m }
  {
    \gdut_section* { #1 }
  }
%% 定义成果列表
\newenvironment{results}
     {\list{\@biblabel{\@arabic\c@enumiv}}%
           {\settowidth\labelwidth{\@biblabel{99}}%
            \leftmargin\labelwidth
            \advance\leftmargin\labelsep
            \@openbib@code
            \usecounter{enumiv}%
            \let\p@enumiv\@empty
            \renewcommand\theenumiv{\@arabic\c@enumiv}
            \setlength{\itemsep}{0pt}
            \setlength{\parsep}{0pt}}%
      \sloppy
      \clubpenalty4000
      \@clubpenalty \clubpenalty
      \widowpenalty4000%
      \sfcode`\.\@m}
     {\def\@noitemerr
       {\@latex@warning{Empty `thebibliography' environment}}%
      \endlist}
%% 定义独创性声明
\NewDocumentCommand {\gdutstatement} { s O{} o o } {
  \IfBooleanTF {#1}
  {
    \bool_if:NTF \l__gdut_open_bool
    {
      \clearpage
    }
    {
      \if@openright\cleardoublepage\else\clearpage\fi
    }
    \phantomsection
    \addcontentsline{toc}{chapter}{学位论文独创性声明及学位论文版权使用授权声明}
    \addcontentsline{tec}{chapter}{Statement~of~original~authorship~and~copyright~licensing~declaration}
    \includepdf {#2}
  }
  {
    \phantomsection
    \gdut_chapter*{学位论文独创性声明}
    \addcontentsline{toc}{chapter}{学位论文独创性声明及学位论文版权使用授权声明}
    \addcontentsline{tec}{chapter}{Statement~of~original~authorship~and~copyright~licensing~declaration}
    \markboth{学位论文独创性声明及学位论文版权使用授权声明}{}
    \vspace*{\baselineskip+0.9\ccwd}
    \c__gdut_orig_decl_text_tl\par
    \vspace*{\baselineskip}
    \hspace*{13\ccwd} 论文作者签名：
    \parbox[c][\baselineskip][c]{4\ccwd}
      {
        \IfNoValueTF{#3}
          { \mbox{} }
          {
            \includegraphics[width=4\ccwd, height=\baselineskip, keepaspectratio]{#3}
          }
      }
    \hspace*{\ccwd}日期：#2\par
    \ctexset{chapter/break = {}}
    \vspace*{3\baselineskip}
    \gdut_chapter*{学位论文版权使用授权声明}
    \vspace*{\baselineskip+0.9\ccwd}
    \c__gdut_auth_decl_text_tl\par
    \vspace*{\baselineskip}
    \hspace*{13\ccwd} 论文作者签名：
    \parbox[c][\baselineskip][c]{4\ccwd}
      {
        \IfNoValueTF{#3}
          { \mbox{} }
          {
            \includegraphics[width=4\ccwd, height=\baselineskip, keepaspectratio]{#3}
          }
      }
    \hspace*{\ccwd}日期：#2\par
    \vspace*{\baselineskip}
    \hspace*{13\ccwd} 指导教师签名：
    \parbox[c][\baselineskip][c]{4\ccwd}
      {
        \IfNoValueTF{#3}
          { \mbox{} }
          {
            \includegraphics[width=4\ccwd, height=\baselineskip, keepaspectratio]{#4}
          }
      }
    \hspace*{\ccwd}日期：#2\par
    \bool_if:NTF \l__gdut_open_bool
    {
      \ctexset{chapter/break = \clearpage}
    }
    {
      \ctexset{chapter/break = \if@openright\cleardoublepage\else\clearpage\fi}
    }
  }
}
\cs_new:Npn \gdutappendix
  {
    \ctexset{chapter/numbering=true}
    \appendix
    \makeatletter
    \ExplSyntaxOn
    \xpatchcmd { \CTEX@addtocline }
    {
      chapter/name   = { Chapter\  },
      chapter/number = \arabic{ chapter },
    }
    {
      chapter/name   = { Appendix\  },
      chapter/number = \Alph{ chapter },
    }
    { } { \fail }
    \ExplSyntaxOff
    \makeatother
  }
\NewDocumentEnvironment { abstract  } { }
  {
    \pagestyle{fancy}
    \__gdut_abstract_begin:
  }
  {
    \__gdut_abstract_end:
  }
\NewDocumentEnvironment { abstract* } { }
  {
    \__gdut_abstract_en_begin:
  }
  {
    \__gdut_abstract_en_end:
  }
\cs_new_protected:Npn \__gdut_abstract_begin:
  { 
    \pagestyle      { fancy }
    \pagenumbering  { Roman }
    \chapter { 摘要 } { ABSTRACT ( IN~CHINESE ) }
  }
\cs_new_protected:Npn \__gdut_abstract_en_begin:
  { \chapter { ABSTRACT } { ABSTRACT ( IN~ENGLISH ) } }
\cs_new_protected:Npn \__gdut_abstract_end:
  {
    \__gdut_keywords:nNn
      { \sffamily 关键词： }
      \l__gdut_info_keywords_clist { ； }
  }
\cs_new_protected:Npn \__gdut_abstract_en_end:
  {
    \__gdut_keywords:nNn
      { \bfseries Key~words:~ }
      \l__gdut_info_keywords_en_clist { ; ~ }
  }
\cs_new_protected:Npn \__gdut_keywords:nNn #1#2#3
  {
    \par \mode_leave_vertical: \par \noindent
    \group_begin: #1 \group_end:
        \clist_use:Nn #2 {#3} \par
  }
\NewDocumentEnvironment { notation } { O { l p { 7.5 cm } } }
  {
    \__gdut_notation_begin:
    \group_begin: \zihao{5}
      \__gdut_notation_long_table_setup:
      \longtable {#1}
  }
  {
      \endlongtable
    \group_end:
  }
\cs_new_protected:Npn \__gdut_notation_begin:
  {
    \chapter{物理量名称及符号表}{Table~of~physical~quantity~names~and~symbols}
  }
\cs_new_protected:Npn \__gdut_notation_long_table_setup:
  {
    \dim_set_eq:NN \LTpre  \c_zero_dim
    \dim_set_eq:NN \LTpost \c_zero_dim
  }
\bool_new:N   \l__gdut_bibtex_bool
\tl_new:N     \l__gdut_bib_style_tl
\tl_new:N     \l__gdut_bib_gb_style_tl
\tl_new:N     \l__gdut_cite_style_tl
\clist_new:N  \l__gdut_bib_resource_clist
\keys_define:nn { gdut / style }
  {
    bib-backend .choice:,
    bib-backend .value_required:n = true,
    bib-backend / bibtex   .code:n =
      { \bool_set_true:N  \l__gdut_bibtex_bool },
    bib-backend / biblatex .code:n =
      { \bool_set_false:N \l__gdut_bibtex_bool },
    bib-style .choice:,
    bib-style .value_required:n = true,
    bib-style / numerical    .code:n =
      {
        \tl_set:Nn  \l__gdut_bib_gb_style_tl { numerical  }
        \tl_clear:N \l__gdut_bib_style_tl
      },
    bib-style / author-year .code:n =
      {
        \tl_set:Nn  \l__gdut_bib_gb_style_tl { author-year }
        \tl_clear:N \l__gdut_bib_style_tl
      },
    bib-style / unknown     .code:n =
      { \tl_set_eq:NN \l__gdut_bib_style_tl \l_keys_value_tl },
    cite-style .code:n =
      {
        \bool_if:NTF \l__gdut_bibtex_bool
          { \__gdut_warning:n { cite-style-not-available } }
          { \tl_set:Nn \l__gdut_cite_style_tl {#1} }
      },
    bib-resource .clist_set:N = \l__gdut_bib_resource_clist
  }
\__gdut_msg_new:nn { cite-style-not-available }
  { Option~ "cite-style"~ is~ not~ available~ in~ BibTeX. }
\ctex_at_end_preamble:n
  {
    \bool_if:NT \l__gdut_bibtex_bool
      {
        \RequirePackage [ sort & compress ] { natbib }
        \__gdut_bibtex_setup:
      }
  }
\__gdut_gadd_ltxhook:nn { env/document/begin }
  {
    \bool_if:NF \l__gdut_bibtex_bool
      {
        \__gdut_biblatex_pre_setup:
        \RequirePackage { biblatex }
        \__gdut_biblatex_post_setup:
      }
  }
\cs_new_protected:Npn \__gdut_bibtex_setup:
  {
    \tl_if_empty:NTF \l__gdut_bib_style_tl
      {
        \tl_if_eq:VnTF \l__gdut_bib_gb_style_tl { numerical }
          {
            \bibliographystyle { gbt7714-numerical }
            \__gdut_set_cite_style_numerical:
          }
          {
            \tl_if_eq:VnT \l__gdut_bib_gb_style_tl { author-year }
              {
                \bibliographystyle { gbt7714-author-year }
                \__gdut_set_cite_style_author_year:
                \cs_set_eq:NN \cite \citep
              }
          }
      }
      { \exp_args:NV \bibliographystyle \l__gdut_bib_style_tl }
    \cs_set:Npn \bibsection { \chapter{参考文献}{References} }
    \NewDocumentCommand \printbibliography { o }
      {
        \exp_args:NV \bibliography \l__gdut_bib_resource_clist
        \IfValueT {##1}
          { \__gdut_warning:nn { invalid-option-in-bibtex } {##1} }
      }
    \setlength { \bibsep } { 0pt }
  }
\__gdut_msg_new:nn { invalid-option-in-bibtex }
  { Option(s)~ "#1"~ are~ invalid~ in~ BibTeX. }
\cs_new_protected:Npn \__gdut_biblatex_pre_setup:
  {
    \tl_if_empty:NTF \l__gdut_bib_style_tl
      {
        \tl_if_eq:VnTF \l__gdut_bib_gb_style_tl { numerical }
          { \__gdut_pass_options_to_biblatex:n { style = gb7714-2015 } }
          {
            \tl_if_eq:VnT \l__gdut_bib_gb_style_tl { author-year }
              { \__gdut_pass_options_to_biblatex:n { style = gb7714-2015ay } }
          }
      }
      { \__gdut_pass_options_to_biblatex:n { style = \l__gdut_bib_style_tl } }
    \tl_if_empty:NF \l__gdut_cite_style_tl
      { \__gdut_pass_options_to_biblatex:n { citestyle = \l__gdut_cite_style_tl } }
    \__gdut_pass_options_to_biblatex:n { backend = biber, hyperref = manual, natbib }
  }
\cs_new_protected:Npn \__gdut_biblatex_post_setup:
  {
    \clist_map_function:NN \l__gdut_bib_resource_clist \addbibresource
    \__gdut_biblatex_allow_url_break:
    \defbibheading { bibliography } [ 参考文献 ] { \chapter{##1}{References}  }
    \setlength { \bibitemsep } { 0pt }
  }
\cs_new_protected:Npn \__gdut_pass_options_to_biblatex:n #1
  { \PassOptionsToPackage {#1} { biblatex } }
\cs_new:Npn \__gdut_biblatex_allow_url_break:
  {
    \int_set_eq:NN \c@biburlucpenalty  \c_one_int
    \int_set_eq:NN \c@biburlnumpenalty \c_one_int
    \int_set_eq:NN \c@biburllcpenalty  \c_one_int
  }
\cs_new:Npn \__gdut_set_cite_style_numerical:
  {
    \NAT@numberstrue \NAT@supertrue
    \cs_set:Npn \NAT@open  { [  }
    \cs_set:Npn \NAT@close { ]  }
    \cs_set:Npn \NAT@sep   { ,~ }
  }
\cs_new:Npn \__gdut_set_cite_style_author_year:
  {
    \NAT@numbersfalse
    \cs_set_eq:NN \NAT@open  \c__gdut_fwid_left_paren_tl
    \cs_set_eq:NN \NAT@close \c__gdut_fwid_right_paren_tl
    \cs_set_eq:NN \NAT@sep   \c__gdut_fwid_semicolon_tl
    \cs_set_eq:NN \NAT@aysep \c__gdut_fwid_comma_tl
    \cs_set_eq:NN \NAT@yrsep \c__gdut_ideo_comma_tl
  }
\NewDocumentCommand \hypersetup { m }
  { \gdut_hyperref_setup:n {#1} }
\cs_new_protected:Npn \gdut_hyperref_setup:n #1
  { \clist_gput_right:Nn \g__gdut_to_hyperref_clist {#1} }
\cs_new:Npn \__gdut_set_hyperlink_color_key:n #1
  {
    hyperlink-color / \clist_item:nn {#1} {1} .code:n =
      {
        \__gdut_define_hyperlink_color:nnn
          { \clist_item:nn {#1} {2} }
          { \clist_item:nn {#1} {3} }
          { \clist_item:nn {#1} {4} }
        \gdut_hyperref_setup:n
          {
            linkcolor = gdut@link, linkbordercolor = gdut@link,
            urlcolor  = gdut@url,  urlbordercolor  = gdut@url,
            citecolor = gdut@cite, citebordercolor = gdut@cite
          }
      },
  }
\cs_new_protected:Npn \__gdut_define_hyperlink_color:nnn #1#2#3
  {
    \definecolorset { HTML } { gdut@ } { }
      { link, #1; url, #2; cite, #3 }
  }
\keys_define:nx { gdut / style }
  {
    hyperlink .choice:,
    hyperlink .value_required:n = true,
    hyperlink / border .code:n = { },
    hyperlink / color  .code:n =
      { \gdut_hyperref_setup:n { colorlinks = true } },
    hyperlink / none   .code:n =
      { \gdut_hyperref_setup:n { hidelinks         } },
    hyperlink-color .choice:,
    hyperlink-color .value_required:n = true,
    \clist_map_function:nN
      {
        { autumn,    D70000, D75F00, AF8700 },
        { business,  D14542, 295497, 1F6E43 },
        { classic,   FF0000, 0000FF, 00FF00 },
        { default,   990000, 0000B2, 007F00 },
        { elegant,   961212, C31818, 9B764F },
        { fantasy,   FF4A19, FF3F94, 934BA1 },
        { material,  E91E63, 009688, 4CAF50 },
        { science,   CA0619, 389F9D, FF8920 },
        { summer,    00AFAF, 5F5FAF, 5F8700 },
        { graylevel, 616161, 616161, 616161 },
        { prl,       2D3092, 2D3092, 2D3092 }
      }
      \__gdut_set_hyperlink_color_key:n
  }
\cs_new:Npn \gdut_allow_url_break:
  {
    \cs_new:Npn \__gdut_add_url_break_points:
      { \tl_map_function:NN \c__gdut_url_break_points_tl \do }
    \__gdut_appto_cmd:Nn \UrlBreaks
      { \UrlOrds \__gdut_add_url_break_points: }
  }
\tl_const:Nn \c__gdut_url_break_points_tl
  {
    abcdefghijklmnopqrstuvwxyz
    ABCDEFGHIJKLMNOPQRSTUVWXYZ
    0123456789
  }
\ctex_at_end_preamble:n
  {
    \RequirePackage { hyperref }
    \hypersetup
      {
        bookmarksnumbered = true,
        psdextra          = true,
        unicode           = true,
        pdftitle    = \l__gdut_info_title_tl,
        pdfauthor   = \l__gdut_info_author_tl,
        pdfkeywords = \l__gdut_info_keywords_clist,
      }
    \exp_args:NV \hypersetup \g__gdut_to_hyperref_clist
    \gdut_allow_url_break:
    \bool_if:NF \l__gdut_bibtex_bool { \BiblatexManualHyperrefOn }
  }
\ctex_at_end_package:nn { hyperref }
  {
    \pdfstringdefDisableCommands
      {
        \cs_set_eq:NN \gdut@kai \prg_do_nothing:
        \cs_set_eq:NN \quad     \c_space_tl
        \cs_set_eq:NN \qquad    \c_space_tl
      }
  }
\cs_new:Npn \gduttableofcontents
  {
    \renewcommand \cftchapaftersnumb { \hspace{6.5pt} }
    \enSectionTitle { CONTENTS ( IN~CHINESE ) }
    \tableofcontents
    \renewcommand \cftchapaftersnumb { \hspace{0pt}   }
    \enSectionTitle { CONTENTS ( IN~ENGLISH ) }
    \enTableOfContents
  }
\ctex_at_end_preamble:n
{
  \bool_if:NTF \l__gdut_bibtex_bool
  {
    \NewDocumentCommand {\gdutcite} { s O{} m }
    {
      \IfBooleanTF {#1}
      {
        \setcitestyle{numbers}
        \cite[#2]{#3}
        \setcitestyle{super}
      }
      {
        \cite[#2]{#3}
      }
    }
  }
  {
    \NewDocumentCommand {\gdutcite} { s O{} m }
    {
      \IfBooleanTF {#1}
      {
        \parencite[#2]{#3}
      }
      {
        \cite[#2]{#3}
      }
    }
  }
}
\keys_define:nn { gdut }
  {
    info    .meta:nn = { gdut / info    } {#1},
    style   .meta:nn = { gdut / style   } {#1},
    theorem .meta:nn = { gdut / theorem } {#1}
  }
\keys_set:nn { gdut }
  {
    style   / cover             = false,
    style   / open              = true,
    style   / font              = times,
    style   / math-font         = times,
    style   / cjk-font          = fandol,
    style   / fullwidth-stop    = false,
    style   / hyperlink-color   = default,
    style   / bib-style         = numerical,
    info    / supervisor-three  = none,
    info    / secret-level      = none,
    info    / date              = { 2021/5/1 },
    theorem / header-font       = bf,
    theorem / body-font         = rm,
    theorem / indent            = en,
    theorem / interval          = dot,
    theorem / punct             = colon,
    theorem / braces            = paren,
    theorem / qed               = \qedsymbol,
  }
\NewDocumentCommand \gdutsetup { m }
  { \keys_set:nn { gdut } {#1} }

\cs_new:Npn \gdut_name_jobname_spacer: #1
  {
    \quad #1
  }
\cs_new:Npn \gdutcover
  {
    \setlength{\paperwidth}{420mm}
    \setlength{\pdfpagewidth}{420mm}
    \setlength{\paperheight}{297mm}
    \setlength{\pdfpageheight}{297mm}
    \newgeometry{margin=0pt}
      \noindent\begin{minipage}[c][29.7cm]{20.78cm}%
        \mbox{}%
      \end{minipage}%
      \parbox[c]{0.44cm}{%
        \centering\zihao{5}\linespread{1.0807}\selectfont%
        \mbox{}\vfill%
        \l__gdut_info_title_tl\par%
        \vspace{5cm}%
        \l__gdut_info_author_tl\par%
        \vspace{5cm}%
        \exp_args:No \coverdate{\l__gdut_info_date_tl}\par%
        \mbox{}\vfill%
      }%
      \noindent\begin{minipage}[c][29.7cm]{20.78cm}%
        \centering
        \vspace*{2cm}
        \begingroup \centering\sffamily\zihao{2} \l__gdut_info_title_tl \par \endgroup
        \vspace*{3cm}
        \begingroup \centering\zihao{4}\bfseries
        \begin{tabular}{c>{\centering\arraybackslash}p{16\ccwd}}
          \multirow{4}*{
            \begin{CJKfilltwosides*}{0pt}
              作者姓名：\\
              导师姓名：\\
              学科（专业）或领域名称：\\
              论文答辩年月：
            \end{CJKfilltwosides*}
          } & \l__gdut_info_author_tl \\
          \cline{2-2}
          & \l__gdut_info_supervisor_name_tl
          \str_if_eq:NNTF \l__gdut_info_supervisor_three_tl {none}
          { \\ }
          {
            \quad \l__gdut_info_supervisor_two_name_tl \\
          }
          \cline{2-2}
          & \l__gdut_info_major_tl \\
          \cline{2-2}
          & \exp_args:No \coverdate{\l__gdut_info_date_tl} \\
          \cline{2-2}
        \end{tabular}
        \par \endgroup
      \end{minipage}%
    \restoregeometry
    \setlength{\paperwidth}{210mm}
    \setlength{\pdfpagewidth}{210mm}
    \setlength{\paperheight}{297mm}
    \setlength{\pdfpageheight}{297mm}
    \newpage
  }
\cs_new:Npn \gdutmaketitle
  {
    \__gdut_background_type:
    \frontmatter
    \pagestyle{empty}
    \pagenumbering{Alph}
    \bool_if:NTF \l__gdut_cover_bool
    {
      \gdutcover
      \linespread{\ZhLS@bodylinespread}\selectfont
    }
    { }
    \vspace*{0.4\baselineskip-1.5pt}
    \begingroup \centering
      \begin{tabular}{>{\zihao{4}}r@{\hspace*{7\ccwd}}>{\zihao{4}\raggedright\arraybackslash}p{6\ccwd}@{\hspace*{5\ccwd}}>{\zihao{4}}p{12\ccwd}}
        中图分类号：  &        & 学校代号：11845 \\[5pt]
        UDC：         & 密级：\bool_if:NT \l__gdut_secret_bool {\l__gdut_info_secret_level_tl} & 学\hspace*{2\ccwd}号：\l__gdut_info_student_id_tl
      \end{tabular}
    \par \endgroup
    \vspace*{1.5\baselineskip+4pt}
    \begingroup \centering\bfseries\zihao{-2} 广东工业大学 \__gdut_thesis_type 论文\par \endgroup
    \begingroup \centering\zihao{4} （ \l__gdut_info_degree_tl ） \par \endgroup
    \vspace*{0.8\baselineskip+0.75pt}
    \begingroup \centering\sffamily\zihao{2} \l__gdut_info_title_tl\par \endgroup
    \vspace*{\baselineskip+5.75pt}
    \begingroup \centering\zihao{3} \l__gdut_info_author_tl\par \endgroup
    \vspace*{7.5\baselineskip}
    \begingroup \centering\zihao{4}
    \begin{tabular}{c>{\centering\arraybackslash}p{16\ccwd}}
      \str_if_eq:NNTF \l__gdut_info_supervisor_three_tl {none}
      {
        \str_if_eq:NNTF \l__gdut_info_supervisor_two_tl {none}
        {
          \multirow{5}*
        }
        {
          \multirow{6}*
        }
          {
            \begin{CJKfilltwosides*}{0pt}
              指导教师姓名、职称：\\
              \str_if_eq:NNTF \l__gdut_info_supervisor_two_tl {none}
              { }
              {
                \\
              }
              \__gdut_professional_type ：\\
              学生所属学院：\\
              答辩委员会主席：\\
              论文答辩日期：
            \end{CJKfilltwosides*}
          }
        & \l__gdut_info_supervisor_name_tl \gdut_name_jobname_spacer: \l__gdut_info_supervisor_jobname_tl \\
        \cline{2-2}
        \str_if_eq:NNTF \l__gdut_info_supervisor_two_tl {none}
        { }
        {
          & \l__gdut_info_supervisor_two_name_tl \gdut_name_jobname_spacer: \l__gdut_info_supervisor_two_jobname_tl \\ \cline{2-2}
        }
      }
      {
        \multirow{6}*{
          \begin{CJKfilltwosides*}{0pt}
            指导教师姓名、职称：\\
            企业导师姓名、职称：\\
            \__gdut_professional_type ：\\
            学生所属学院：\\
            答辩委员会主席：\\
            论文答辩日期：
          \end{CJKfilltwosides*}
        }
        & \l__gdut_info_supervisor_name_tl        \gdut_name_jobname_spacer: \l__gdut_info_supervisor_jobname_tl        \qquad
          \l__gdut_info_supervisor_two_name_tl    \gdut_name_jobname_spacer: \l__gdut_info_supervisor_two_jobname_tl    \\
        \cline{2-2}
        & \l__gdut_info_supervisor_three_name_tl  \gdut_name_jobname_spacer: \l__gdut_info_supervisor_three_jobname_tl  \\
        \cline{2-2}
      }
      & \l__gdut_info_major_tl \\
      \cline{2-2}
      & \l__gdut_info_department_tl \\
      \cline{2-2}
      & \l__gdut_info_chairman_clist \\
      \cline{2-2}
      & \exp_args:No \zhdate{\l__gdut_info_date_tl} \\
      \cline{2-2}
    \end{tabular}
    \par \endgroup
    \newpage
    \begingroup \centering\zihao{4}
      A~Dissertation~Submitted~to~Guangdong~University~of~Technology\\[-0.15\baselineskip]
      in~Partial~Fulfillment~of~the~Requirement\\[-0.15\baselineskip]
      for~the~Degree~of~\l__gdut_info_degree_en_tl
    \par \endgroup
    \vspace*{3\baselineskip}
    \begingroup \centering\zihao{-2}\sffamily
      \l__gdut_info_title_en_tl
    \par \endgroup
    \vspace*{5\baselineskip}
    \begingroup \centering\zihao{-3}\sffamily
      Candidate:~\l__gdut_info_author_en_tl\\
      Supervisor:~\l__gdut_info_supervisor_en_tl
    \par \endgroup
    \vspace*{8\baselineskip}
    \begingroup \centering\zihao{-4}\sffamily\linespread{1.15}\selectfont
      \exp_args:No \engdate{\l__gdut_info_date_tl}\\
      School~of~\l__gdut_info_department_en_tl\\
      Guangdong~University~of~Technology\\
      Guangzhou,~Guangdong,~P.~R.~China,~510006
    \par \endgroup
    \clearpage
    \pagestyle{fancy}
  }
% 设置封面背景
\clist_const:Nn \c__gdut_background_clist
  {
    \backgroundsetup{
      scale     = 0.4796,
      position  = {38.5cm,-25.7cm},
      contents  = { \includegraphics{cover-background/doctor.jpeg}    }
      },
    \backgroundsetup{
      scale     = 0.4787,
      position  = {38.5cm,-25.7cm},
      contents  = { \includegraphics{cover-background/master.jpeg}    }
      },
    \backgroundsetup{
      scale     = 0.38327,
      position  = {48.1cm,-32.1cm},
      contents  = { \includegraphics{cover-background/promaster.jpeg} }
      }
  }
\cs_new_protected:Npn \__gdut_background_type:
  {
    \bool_if:NTF \l__gdut_cover_bool
    {
      \clist_item:Nn \c__gdut_background_clist
      { \g__gdut_thesis_type_int }
    }
    {
      \backgroundsetup{ contents = { } }
    }
  }
\allowdisplaybreaks[4]
\endinput