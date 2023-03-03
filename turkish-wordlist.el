;;; turkish-wordlist.el ---  -*- lexical-binding: t; -*-

;;; Commentary:
;; 

;;; Code:

(ert-deftest turkish-wordlist-test-list-not-empty ()
  (should-not (length= turkish-wordlist-list 0)))

(ert-deftest turkish-wordlist-test-filtered-list-first-word-equal ()
  (should (equal (plist-get (elt turkish-wordlist-list 0) :madde)
                 "-den yana")))

(defun turkish-wordlist--download (newname)
  (url-copy-file "https://sozluk.gov.tr/autocomplete.json" newname t))

(defun turkish-wordlist--json-parse-file (filename)
  (with-temp-buffer
    (insert-file-contents filename)
    (json-parse-buffer :object-type 'plist :array-type 'list)))

(setq turkish-wordlist-list
      (turkish-wordlist--json-parse-file "autocomplete.json"))

(defun turkish-wordlist--filter ()
  (let (wordlist)
    (dolist (word turkish-wordlist-list)
      (add-to-list 'wordlist (plist-get word :madde)))
    (setq turkish-wordlist-filtered-list wordlist)))

(defun turkish-wordlist--write-file (filename)
  (write-region (format "%S" turkish-wordlist-filtered-list) nil filename))

(defun turkish-wordlist ()
  (interactive)
  (let ((filename "turkish-wordlist"))
    (turkish-wordlist--download)
    (turkish-wordlist--filter)
    (turkish-wordlist--write-file filename)))

(defun turkish-wordlist-random-word ()
  (interactive)
  (when (fboundp 'turkish-wordlist-filtered-list)
    (elt turkish-wordlist-filtered-list
         (random (length turkish-wordlist-filtered-list)))))

(provide 'turkish-wordlist)

;;; turkish-wordlist.el ends here
