echo "compare all automated verification files with the output of the test cases:"
fc category_1_DVM_issue_verification.csv category_1_DVM_issue_verification-2.csv > file_compare_script_output_verification-2.txt
fc category_2_DVM_issue_verification.csv category_2_DVM_issue_verification-2.csv >> file_compare_script_output_verification-2.txt
fc category_3_DVM_issue_verification.csv category_3_DVM_issue_verification-2.csv >> file_compare_script_output_verification-2.txt
fc category_4_script_output_verification.txt category_4_script_output_verification-2.txt >> file_compare_script_output_verification-2.txt
fc category_5_DVM_issue_verification.csv category_5_DVM_issue_verification-2.csv >> file_compare_script_output_verification-2.txt
fc category_6_DVM_issue_verification.csv category_6_DVM_issue_verification-2.csv >> file_compare_script_output_verification-2.txt
fc category_6_DVM_PTA_rule_verification.csv category_6_DVM_PTA_rule_verification-2.csv >> file_compare_script_output_verification-2.txt
fc category_6_DVM_rule_verification.csv category_6_DVM_rule_verification-2.csv >> file_compare_script_output_verification-2.txt
fc category_7_DVM_config_error_verification_1.csv category_7_DVM_config_error_verification_1-2.csv >> file_compare_script_output_verification-2.txt
fc category_7_DVM_config_error_verification_2.csv category_7_DVM_config_error_verification_2-2.csv >> file_compare_script_output_verification-2.txt
fc category_7_DVM_config_error_verification_3.csv category_7_DVM_config_error_verification_3-2.csv >> file_compare_script_output_verification-2.txt
fc category_7_script_output_verification.txt category_7_script_output_verification-2.txt >> file_compare_script_output_verification-2.txt
fc category_8_script_output_verification.txt category_8_script_output_verification-2.txt >> file_compare_script_output_verification-2.txt
echo ""
echo ""
fc file_compare_script_output_verification.txt file_compare_script_output_verification-2.txt > summary_verification_results.txt
pause