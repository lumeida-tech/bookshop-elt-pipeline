{% macro get_mois(date_col) %}
CASE MONTH({{ date_col }})
    WHEN 1  THEN 'janvier'
    WHEN 2  THEN 'fevrier'
    WHEN 3  THEN 'mars'
    WHEN 4  THEN 'avril'
    WHEN 5  THEN 'mai'
    WHEN 6  THEN 'juin'
    WHEN 7  THEN 'juillet'
    WHEN 8  THEN 'aout'
    WHEN 9  THEN 'septembre'
    WHEN 10 THEN 'octobre'
    WHEN 11 THEN 'novembre'
    WHEN 12 THEN 'decembre'
END
{% endmacro %}


{% macro get_jour(date_col) %}
CASE DAYOFWEEK({{ date_col }})
    WHEN 1 THEN 'dimanche'
    WHEN 2 THEN 'lundi'
    WHEN 3 THEN 'mardi'
    WHEN 4 THEN 'mercredi'
    WHEN 5 THEN 'jeudi'
    WHEN 6 THEN 'vendredi'
    WHEN 7 THEN 'samedi'
END
{% endmacro %}
