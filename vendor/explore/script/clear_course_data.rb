return if Rails.env != 'development'

KnowledgeNetPlanStore::Plan.delete_all
KnowledgeNetPlanStore::Topic.delete_all
KnowledgeNetPlanStore::Tutorial.delete_all