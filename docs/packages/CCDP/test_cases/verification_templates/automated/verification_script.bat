echo "compare all automated verification files with the output of the test cases:"
fc category_1_script_output_verification.txt category_1_script_output_verification-2.txt > file_compare_script_output_verification-2.txt
fc category_2_CCDP_verification.csv category_2_CCDP_verification-2.csv >> file_compare_script_output_verification-2.txt
fc category_2_DVM_verification.csv category_2_DVM_verification-2.csv >> file_compare_script_output_verification-2.txt
fc category_3_script_output_verification.txt category_3_script_output_verification-2.txt >> file_compare_script_output_verification-2.txt
echo ""
echo ""
fc file_compare_script_output_verification.txt file_compare_script_output_verification-2.txt > summary_verification_results.txt
pause