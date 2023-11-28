source("rcode2txt.R")
source("load_rcode_data.R")

mw_all <- c(
  "space_placeholder",
  "assign_arrow_left_placeholder",
  "assign_arrow_right_placeholder",
  "global_assign_arrow_left_placeholder",
  "global_assign_arrow_right_placeholder",
  "pipe_arrow_right_placeholder",
  "pipe_arrow_left_placeholder",
  "matching_operators_placeholder",
  "matrix_multiplication_placeholder",
  "outer_product_placeholder",
  "magrittr_forward_pipe_placeholder",
  "magrittr_backward_pipe_placeholder",
  "kronecker_placeholder",
  "integer_division_placeholder",
  "default_value_placeholder",
  "modulo_placeholder",
  "namespace_placeholder",
  "triple_colon_placeholder",
  "comment_start_placeholder",
  "hyphen_placeholder",
  "plus_sign_placeholder",
  "asterisk_placeholder",
  "equal_sign_placeholder",
  "backslash_placeholder",
  "forwardslash_placeholder",
  "single_quote_placeholder",
  "double_quote_placeholder",
  "exclamation_point_placeholder",
  "dollar_sign_placeholder",
  "at_symbol_placeholder",
  "percent_symbol_placeholder",
  "carrot_symbol_placeholder",
  "and_symbol_placeholder",
  "open_parentheses_placeholder",
  "close_parentheses_placeholder",
  "open_brace_placeholder",
  "close_brace_placeholder",
  "open_bracket_placeholder",
  "close_bracket_placeholder",
  "colon_placeholder",
  "semicolon_placeholder",
  "question_mark_placeholder",
  "less_than_sign_placeholder",
  "greater_than_sign_placeholder",
  "grave_accent_placeholder",
  "approximate_placeholder",
  "period_placeholder",
  "comma_placeholder"
)

# Create tokens and dfm
code_tokens <- code_txt %>%
  corpus() %>%
  tokens(remove_punct = TRUE, remove_symbols = TRUE, what = "word")

code_dfm <- code_tokens %>%
  dfm() %>%
  dfm_weight(scheme = "prop")


# Convert dfm to data frame using as.data.frame.matrix
code_dfm_df <- as.data.frame.matrix(code_dfm)

# Add the document_id column
code_dfm_df$document_id <- rownames(code_dfm_df)

# Reorder columns
code_dfm_df <- code_dfm_df %>%
  select(document_id, names(sort(colMeans(.[,-ncol(code_dfm_df)]), decreasing = TRUE)))


code_dfm_df <- code_dfm_df %>% 
  right_join(code_meta) %>% 
  dplyr::select(document_id, author_id, everything()) %>% 
  as_tibble()

train_dfm <- code_dfm_df %>% dplyr::filter(author_id == "gabe" | author_id == "zach")
test_dfm <- code_dfm_df %>% dplyr::filter(author_id == "disputed")

cv_fit <- cv.glmnet(as.matrix(train_dfm_v2_1[, -1]), train_dfm_v2_1[, 1], family = "binomial")

plot(cv_fit)

"""
set.seed(123)
valid_split <- initial_split(train_dfm, .8)
train_dfm_v2 <- analysis(valid_split)
train_valid <- assessment(valid_split)

train_dfm_v2_1 <- train_dfm_v2 %>%
  mutate(document_id = factor(document_id)) %>%
  column_to_rownames("document_id")

train_valid_1 <- train_valid %>% 
  column_to_rownames("document_id")

cv_fit <- cv.glmnet(as.matrix(train_dfm_v2_1[, -1]), train_dfm_v2_1[, 1], family = "binomial")

plot(cv_fit)

lambda_min <- cv_fit$lambda.min
lambda_lse <- cv_fit$lambda.1se

coef(cv_fit, s = "lambda.min") %>%
  as.matrix() %>%
  data.frame() %>%
  rownames_to_column("Variable") %>%
  dplyr::filter(s1 !=0) %>%
  dplyr::rename(Coeff = s1) %>%
  knitr::kable(digits = 2)

x_test <- model.matrix(author_id ~., train_valid_1)[,-1]

lasso_prob <- predict(cv_fit, newx = x_test, s = lambda_lse, type = "response")

lasso_predict <- ifelse(lasso_prob > 0.5, "zach", "gabe")

lasso_predict %>% 
  data.frame() %>%
  dplyr::rename(Author = s1) %>%
  knitr::kable()

table(pred=lasso_predict, true=train_valid_1$author_id) %>% knitr::kable()

paste0(mean(lasso_predict == train_valid_1$author_id)*100, "%")

train_dfm_v2_2 <- train_dfm_v2 %>%
  mutate(author_id = factor(author_id)) %>%
  column_to_rownames("document_id")

train_valid_2 <- train_valid %>% 
  column_to_rownames("document_id")

cv_fit <- cv.glmnet(as.matrix(train_dfm_v2_2[, -1]), train_dfm_v2_2[, 1], family = "binomial")

coef(cv_fit, s = "lambda.min") %>%
  as.matrix() %>%
  data.frame() %>%
  rownames_to_column("Variable") %>%
  dplyr::filter(s1 !=0) %>%
  dplyr::rename(Coeff = s1) %>%
  knitr::kable(digits = 2)

lambda_min <- cv_fit$lambda.min
lambda_lse <- cv_fit$lambda.1se

x_test <- model.matrix(author_id ~., train_valid_2)[,-1]

lasso_prob <- predict(cv_fit, newx = x_test, s = lambda_lse, type = "response")

lasso_predict <- ifelse(lasso_prob > 0.5, "zach", "gabe")

table(pred=lasso_predict, true=train_valid_1$author_id) %>% knitr::kable()
"""

train_dfm <- train_dfm %>%
#  dplyr::select(document_id, author_id, one_of(mw_all)) %>%
  mutate(author_id = factor(author_id)) %>%
#  select(document_id, author_id, everything()) %>%
  column_to_rownames("document_id")

test_dfm <- test_dfm %>%
#  dplyr::select(document_id, author_id, one_of(mw_all)) %>%
  column_to_rownames("document_id")

cv_fit <- cv.glmnet(as.matrix(train_dfm[, -1]), train_dfm[, 1], family = "binomial")

coef(cv_fit, s = "lambda.min") %>%
  as.matrix() %>%
  data.frame() %>%
  rownames_to_column("Variable") %>%
  dplyr::filter(s1 !=0) %>%
  dplyr::rename(Coeff = s1) %>%
  knitr::kable(digits = 2)

lasso_fit <- glmnet(as.matrix(train_dfm[, -1]), train_dfm[, 1], alpha = 1, family = "binomial", lambda = cv_fit$lambda.min)

x_test <- model.matrix(author_id ~., test_dfm)[,-1]
lasso_prob <- predict(cv_fit, newx = x_test, s = lambda_lse, type = "response")
lasso_predict <- ifelse(lasso_prob > 0.5, "zach", "gabe")

data.frame(lasso_predict, lasso_prob) %>% 
  dplyr::rename(Author = s1, Prob = s1.1) %>%
  knitr::kable(digits = 2)

