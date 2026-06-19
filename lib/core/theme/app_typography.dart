import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Al-Mizan Typography System
/// Headlines: Source Serif 4 — authoritative, academic weight
/// Body & Interface: Plus Jakarta Sans — soft, modern clarity
/// Arabic Script: Amiri/Scheherazade/Noto Naskh — classical Naskh-style
class AppTypography {
  AppTypography._();

  // ── HEADLINES (Source Serif 4) ──

  static TextStyle get displayLarge => GoogleFonts.sourceSerif4(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        height: 1.17,
        letterSpacing: -0.5,
      );

  static TextStyle get displayMedium => GoogleFonts.sourceSerif4(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.25,
      );

  static TextStyle get headlineLarge => GoogleFonts.sourceSerif4(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.29,
      );

  static TextStyle get headlineMedium => GoogleFonts.sourceSerif4(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.33,
      );

  static TextStyle get headlineSmall => GoogleFonts.sourceSerif4(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.36,
      );

  // ── TITLES (Source Serif 4) ──

  static TextStyle get titleLarge => GoogleFonts.sourceSerif4(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  static TextStyle get titleMedium => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.5,
      );

  static TextStyle get titleSmall => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.43,
      );

  // ── BODY (Plus Jakarta Sans) ──

  static TextStyle get bodyLarge => GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        height: 1.56,
      );

  static TextStyle get bodyMedium => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get bodySmall => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.43,
      );

  // ── LABELS (Plus Jakarta Sans — uppercase tracking) ──

  static TextStyle get labelLarge => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.43,
        letterSpacing: 0.5,
      );

  static TextStyle get labelMedium => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.33,
        letterSpacing: 1.0,
      );

  static TextStyle get labelSmall => GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        height: 1.45,
        letterSpacing: 1.2,
      );

  // ── ARABIC TEXT ──

  /// Quranic text — elegant classical Amiri
  static TextStyle get quranArabic => GoogleFonts.amiri(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        height: 2.0,
      );

  /// Hadith text — clean Scheherazade naskh
  static TextStyle get hadithArabic => GoogleFonts.scheherazadeNew(
        fontSize: 22,
        fontWeight: FontWeight.w400,
        height: 1.9,
      );

  /// General Arabic text — Noto Naskh
  static TextStyle get arabicGeneral => GoogleFonts.notoNaskhArabic(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        height: 1.8,
      );

  /// Lightweight Arabic for short labels
  static TextStyle get arabicLight => GoogleFonts.lateef(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        height: 1.7,
      );
}
