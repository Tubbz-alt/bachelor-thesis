#! /usr/bin/perl

# Autor: Piotr K�osowski <pklosows@press.umcs.lublin.pl> Wersja
# pierwsza dzia�aj�ca (0.1a): 1. lutego 1998 r.  

# Skrypt "porzadki" jest napisanym od nowa nast�pc� awkowego skryptu
# "normtext.awk" z lata 96 r., kt�ry z kolei by� rozwini�ciem pomys��w
# Tomasza Przechlewskiego.

# Filtr do robienia porz�dk�w w duchu TeX-a w plikach tekstowych
# (przede wszystkim znaki przestankowe i wstawianie nie�amliwych spacji) 
# Podstawowe zastosowanie to pomoc w konwersji tekst�w napisanych w
# r�nych edytorach. 

# G��wne za�o�enia i ograniczenia:
# - tekst jest podzielony na akapity pustymi wierszami,
# - tekst jest w j�zyku polskim (kodowanie iso-latin2),
# - wn�trze akapit�w z wyj�tkiem linijek zako�czonych przez "\\" mo�e ulega� 
#   przeformatowaniu (pr�ba usuni�cia przeniesie� wyraz�w) (uwaga na ew. 
#   znaki komentarza - "%"!)

# ========================================================================
# Sta�e wykorzystywane w skrypcie

$Odstep = "[\ \t~]";
$NieOdstep = "[^\ \t~]";
$Spojnik = "[aAiIoOuUwWzZ]";
$Litera = "[a-zA-Z�����ʳ����Ӷ�����]";
$NieLitera = "[^a-zA-Z�����ʳ����Ӷ�����]";
$DuzaLitera = "[A-Z��ʣ�Ӧ��]";
$MalaLitera = "[a-z����󶿼]";
$Cyfra = "[0-9]";
$CyfraRzymska = "[IVXL]";

$PominSrodowisko ="(tabular|array|tabbing|figure|equation|eqenarray|verbatim)";
# ========================================================================
sub PolaczWiersze {
# usuni�cie przeniesie�	
	s/($Litera)-$Odstep*\n$Odstep*($MalaLitera)/$1$2/g;
	s/($Litera)-$Odstep*\n$Odstep*-($Litera)/$1\\dywiz $2/g;
	s/\n$Odstep+\n/\\\\\ \\\\\ /g;
	tr/\n/\ /;
};
# ========================================================================
sub PoprawAkapit {
	&PoprawNielamliwe;
	&PoprawPrzestankowe;
};
# ------------------------------------------------------------------------
# Nie�amliwe spacje
sub PoprawNielamliwe {
	&NielamliweSpojniki;
	&NielamliweInicjaly;
	&NielamliweDaty;
	&NielamliweBibliograf;
	&NielamliweJednostki;
	&NielamliweTytuly;
	&NielamliweInne;
	&NielamliweWyliczenia;
};
#  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  
# nie�amliwe spacje przy s�owach jednoliterowych (uwaga na cyfr� rzymsk� "I")
sub NielamliweSpojniki {
	s/([\(,]|$Odstep+)($Spojnik)$Odstep+($Spojnik)$Odstep+/$1$2~$3~/g;
	s/([\(,]|$Odstep+)($Spojnik)$Odstep+/$1$2~/g;
};
#  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  
# nie�amliwe spacje przy inicja�ach
sub NielamliweInicjaly {
	s/($DuzaLitera)\.$Odstep*($DuzaLitera)\.$Odstep*($DuzaLitera$MalaLitera)/$1\.~$2\.~$3/g;
	s/($DuzaLitera)\.$Odstep*($DuzaLitera$MalaLitera)/$1\.~$2/g;
};
#  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  
# nie�amliwe spacje przy skr�tach zwi�zanych z pisowni� daty
sub NielamliweDaty {
	s/($Cyfra)$Odstep*(r|w)\./$1~$2\./g;
	s/($NieLitera)(r|w)\.$Odstep*($Cyfra)/$1$2\.~$3/g;
	s/($CyfraRzymska)$Odstep+w\./$1~w\./g;
};
#  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  
# nie�amliwe spacje przy skr�tach wyst�puj�cych w zapisie bibliograficznym
sub NielamliweBibliograf {
	s/($NieLitera)([sStTzZ]|ss|SS|[vV]ol|[aA]rt)\.$Odstep*($Cyfra|$CyfraRzymska)/$1$2\.~$3/g;
};
#  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  
# nie�amliwe spacje mi�dzy liczb� a skr�tem jednostki miary
$DuzoZer = "tys\\.|mln|mld";
sub NielamliweJednostki {
	s/($Cyfra)$Odstep*($DuzoZer)/$1~$2/g;
	s/($Cyfra|$DuzoZer)$Odstep*([kdcm]?[glmsVAW])($NieLitera)/$1~$2$3/g;
	s/($Cyfra|$DuzoZer)$Odstep*(z�|gr|ha|t|mies|godz|min|sek)($NieLitera)/$1~$2$3$4/g;
};
#  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  
# nie�amliwe spacje po tytu�ach
sub NielamliweTytuly {
	s/($NieLitera)(mgr|dr|prof\.|hab\.|bp|ks\.|o+\.|�w\.|prez\.|przew\.|red\.|min\.|gen\.|p�k|mjr|kpt\.)$Odstep+/$1$2~/g;
}
#  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  
# nie�amliwe spacje przy innych skr�tach
sub NielamliweInne {
	s/($NieLitera)([Tt]ab\.|[Tt]abl\.|[Rr]y[cs]\.|[Rr]ozdz\.|[Nn]r)$Odstep*($Cyfra)/$1$2~$3/g;
};
#  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  
# nie�amliwe p�firety przy wyliczeniach
sub NielamliweWyliczenia {
	s/^-+$Odstep*/---\\enspace\ /;
	s/^($Cyfra+[\.\)\/])$Odstep+/$1\\enspace\ /;
	s/^($Litera[\.\)\/])[\ \t]+/$1\\enspace\ /;
};
# ------------------------------------------------------------------------
# Znaki przestankowe
sub PoprawPrzestankowe {
	&PrzestankowePolpauzy;
	&PrzestankowePauzy;
	&PrzestankoweDywizy;
	&PrzestankoweCudzyslowy;
	&PrzestankoweWielokropki;
	&PrzestankoweOdstepy;
	&PrzestankoweSymbole;
};
#  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  
# p�pauzy
sub PrzestankowePolpauzy {
	s/($Cyfra)$Odstep*-$Odstep*($Cyfra)/$1--$2/g;
};
#  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  
# pauzy
sub PrzestankowePauzy {
	s/$Odstep+-$Odstep+/\ ---\ /g;
	s/$Odstep+---/~---/g;
};
#  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  
# dywizy
sub PrzestankoweDywizy {
	s/($Litera)-($Litera)/$1\\dywiz $2/g;
};
#  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  
# cudzys�owy
sub PrzestankoweCudzyslowy {
	s/^\"/,,/;
	s/($NieLitera)\"($Litera)/$1,,$2/g;
	s/($Odstep)\"($NieOdstep)/$1,,$2/g;
	s/\"$/''/;
	s/($Litera)\"($NieLitera)/$1''$2/g;
	s/($NieOdstep)\"($Odstep)/$1''$2/g;
	s/\\,,/\\\"/g;
};
#  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  
# wielokropki
sub PrzestankoweWielokropki {
	s/\.{5,}/\\dotfill\{\}/g;
	s/\.{3,4}/\\ldots{}/g;
};
#  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  
# odst�py przy znakach przestankowych (uwaga: ryzykowne - du�o wyj�tk�w)
sub PrzestankoweOdstepy {
	s/$Odstep*([\.;:!?\)\]])/$1/g;
	s/$Odstep*,([^,])/,$1/g;
	s/([\.!?;:\)\]])($Litera)/$1 $2/g;
	s/([^,]),($Litera)/$1, $2/g;
	s/([\(\[])$Odstep*/$1/g;
# skr�ty - wyj�tki
	s/m\.\ +in\./m\.in\./g;
	s/p\.\ +n\.\ +e\./p\.n\.e\./g;
	s/l\.\ +c\./l\.c\./g;
	s/w\.\ +c\./w\.c\./g;
# du�e liczby
	1 while (s/(.*\d\d)(\d\d\d)/$1\\,$2/ or s/(.*\d)(\d\d\d)\\,/$1\\,$2\\,/);
};
#  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  
# uporz�dkowanie kolejno�ci nawias klamrowy - znak przestankowy (!!!sprawa 
# zwi�zana z grupowaniem texem - nie do za�atwienia w tym prostym programie)
#  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .  
# symbole niematematyczne 
sub PrzestankoweSymbole {
	s/([^\\])([\$\%])/$1\\$2/g;
	s/([^\$\<])\<([^\$\<])/$1\$\<\$$2/g;
	s/([^\$\>])\>([^\$\>])/$1\$\>\$$2/g;
}
# ========================================================================
# Zmiany w kszta�cie akapitu - usuni�cie przeniesie� i wci�� od marginesu 
# i przeformatowanie na szeroko�� <=70 zn (domy�lna w AUCTeX-u)
sub PrzeformatujAkapit {
	s/$Odstep*\\\\/\ \\\\/g;
	$IloscSlow = split;
	$DlugoscWiersza = length($_[0]);
	for ($i=1; $i<$IloscSlow; $i++) {
		$DlugoscWiersza += length($_[$i]) + 1;
		if (($DlugoscWiersza>70) || ($_[$i-1]=~/\\\\/)) {
			$_[$i-1] .= "\n";
			$DlugoscWiersza = length($_[$i]);
		};
	};
	$_ = join (" ", @_, "\n");
	s/$Odstep\\\\/\\\\/g;
	s/\n*\\\\\n\\\\\n/\n\n/g;
	s/\n$Odstep+/\n/g;
};
# ========================================================================
# G��wny program

$/ = "";
$\ = "\n";

while (<>) {
	if (/\\begin{$PominSrodowisko}/../\\end{$PominSrodowisko}/) {
		next;
	};
	&PolaczWiersze;
	&PoprawAkapit;
	&PrzeformatujAkapit;
} continue { print; };

# Koniec skryptu "porzadki".
