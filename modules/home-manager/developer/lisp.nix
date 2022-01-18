{ config, pkgs, lib, ... }:

with lib;

{

  config = mkIf (config.storvik.developer.lisp.enable || config.storvik.developer.enable)
    {

      home.packages = with pkgs; [
        clpm
        ecl
        sbcl
      ];

      # SBCL config
      home.file.".sbclrc".text = ''
        (setf sb-impl::*default-external-format* :utf-8)
        (setf sb-alien::*default-c-string-external-format* :utf-8)

        ;;; Use CLPM with default configuration.
        ;;;
        ;;; Generated by CLPM 0.5.0

        (require "asdf")
        #-clpm-client
        (when (asdf:find-system "clpm-client" nil)
          ;; Load the CLPM client if we can find it.
          (asdf:load-system "clpm-client")
          (when (uiop:symbol-call :clpm-client '#:active-context)
            ;; If started inside a context (i.e., with `clpm exec` or `clpm bundle exec`),
            ;; activate ASDF integration
            (uiop:symbol-call :clpm-client '#:activate-asdf-integration)))

      '';

      # ECL config
      home.file.".eclrc".text = ''
        ;;; Use CLPM with default configuration.
        ;;;
        ;;; Generated by CLPM 0.5.0

        (require "asdf")
        #-clpm-client
        (when (asdf:find-system "clpm-client" nil)
          ;; Load the CLPM client if we can find it.
          (asdf:load-system "clpm-client")
          (when (uiop:symbol-call :clpm-client '#:active-context)
             ;; If started inside a context (i.e., with `clpm exec` or `clpm bundle exec`),
             ;; activate ASDF integration
             (uiop:symbol-call :clpm-client '#:activate-asdf-integration)))

      '';

      # ASDF source registry
      home.file.".config/common-lisp/source-registry.conf.d/20-clpm-client.conf".text = ''
        ;; -*- mode: common-lisp; -*-
        ;; Auto generated by CLPM version 0.5.0
        (:directory #P"/nix/store/pvivlrz2arkwv4n2zakfwv7l8mqm0p48-clpm-0.4.2/share/clpm/client/")
      '';

      # CLPM sources file
      home.file.".config/clpm/sources.conf".text = ''
        ("quicklisp"
          :type :ql-clpi
          :url "https://quicklisp.common-lisp-project-index.org/")
      '';

    };

}
