#!/bin/bash
perl qna_gen.pl qna_en.json sample_question_en.tex sample_answers_en.tex sample_answers_idx.tex
perl qna_gen.pl qna_ru.json sample_question_ru.tex sample_answers_ru.tex sample_answers_idx.tex

cat qna_en.json |jq -c > qna_en_compact.json
cat qna_ru.json |jq -c > qna_ru_compact.json
