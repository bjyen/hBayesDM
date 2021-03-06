#' @templateVar MODEL_FUNCTION dbdm_prob_weight
#' @templateVar TASK_NAME Description Based Decison Making Task
#' @templateVar MODEL_NAME Probability Weight Function
#' @templateVar MODEL_CITE (Erev et al., 2010; Hertwig et al., 2004; Jessup et al., 2008)
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "opt1hprob", "opt2hprob", "opt1hval", "opt1lval", "opt2hval", "opt2lval", "choice"
#' @templateVar PARAMETERS "tau" (probability weight function), "rho" (subject utility function), "lambda" (loss aversion parameter), "beta" (inverse softmax temperature)
#' @templateVar LENGTH_DATA_COLUMNS 8
#' @templateVar DETAILS_DATA_1 \item{"subjID"}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{"opt1hprob"}{Possiblity of getting higher value of outcome(opt1hval) when choosing option 1.}
#' @templateVar DETAILS_DATA_3 \item{"opt2hprob"}{Possiblity of getting higher value of outcome(opt2hval) when choosing option 2.}
#' @templateVar DETAILS_DATA_4 \item{"opt1hval"}{Possible (with opt1hprob probability) outcome of option 1.}
#' @templateVar DETAILS_DATA_5 \item{"opt1lval"}{Possible (with (1 - opt1hprob) probability) outcome of option 1.}
#' @templateVar DETAILS_DATA_6 \item{"opt2hval"}{Possible (with opt2hprob probability) outcome of option 2.}
#' @templateVar DETAILS_DATA_7 \item{"opt2lval"}{Possible (with (1 - opt2hprob) probability) outcome of option 2.}
#' @templateVar DETAILS_DATA_8 \item{"choice"}{If option 1 was selected, choice == 1; else if option 2 was selected, choice == 2.}
#'
#' @template model-documentation
#'
#' @export
#' @include hBayesDM_model.R
#'
#' @references
#' Erev, I., Ert, E., Roth, A. E., Haruvy, E., Herzog, S. M., Hau, R., ... & Lebiere, C. (2010). A
#'   choice prediction competition: Choices from experience and from description. Journal of
#'   Behavioral Decision Making, 23(1), 15-47.
#'
#' Hertwig, R., Barron, G., Weber, E. U., & Erev, I. (2004). Decisions from experience and the
#'   effect of rare events in risky choice. Psychological science, 15(8), 534-539.
#'
#' Jessup, R. K., Bishara, A. J., & Busemeyer, J. R. (2008). Feedback produces divergence from
#'   prospect theory in descriptive choice. Psychological Science, 19(10), 1015-1022.

dbdm_prob_weight <- hBayesDM_model(
  task_name       = "dbdm",
  model_name      = "prob_weight",
  data_columns    = c("subjID", "opt1hprob", "opt2hprob", "opt1hval", "opt1lval", "opt2hval", "opt2lval", "choice"),
  parameters      = list("tau"    = c(0, 0.8, 1),
                         "rho"    = c(0, 0.7, 2),
                         "lambda" = c(0, 2.5, 5),
                         "beta"   = c(0, 0.2, 1)),
  preprocess_func = function(raw_data, general_info) {
    subjs   <- general_info$subjs
    n_subj  <- general_info$n_subj
    t_subjs <- general_info$t_subjs
    t_max   <- general_info$t_max

    opt1hprob <- array( 0, c(n_subj, t_max))
    opt2hprob <- array( 0, c(n_subj, t_max))
    opt1hval  <- array( 0, c(n_subj, t_max))
    opt1lval  <- array( 0, c(n_subj, t_max))
    opt2hval  <- array( 0, c(n_subj, t_max))
    opt2lval  <- array( 0, c(n_subj, t_max))
    choice    <- array(-1, c(n_subj, t_max))

    for (i in 1:n_subj) {
      subj <- subjs[i]
      t <- t_subjs[i]
      DT_subj <- raw_data[subjid == subj]

      opt1hprob[i, 1:t] <- DT_subj$opt1hprob
      opt2hprob[i, 1:t] <- DT_subj$opt2hprob
      opt1hval[i, 1:t]  <- DT_subj$opt1hval
      opt1lval[i, 1:t]  <- DT_subj$opt1lval
      opt2hval[i, 1:t]  <- DT_subj$opt2hval
      opt2lval[i, 1:t]  <- DT_subj$opt2lval
      choice[i, 1:t]    <- DT_subj$choice
    }

    data_list <- list(
      N         = n_subj,
      T         = t_max,
      Tsubj     = t_subjs,
      opt1hprob = opt1hprob,
      opt2hprob = opt2hprob,
      opt1hval  = opt1hval,
      opt1lval  = opt1lval,
      opt2hval  = opt2hval,
      opt2lval  = opt2lval,
      choice    = choice
    )

    return(data_list)
  }
)

