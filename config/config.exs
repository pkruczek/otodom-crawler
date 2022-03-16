import Config

config :scraper,
  closespider_timeout: 10,
  concurrent_requests_per_domain: 8,
  middlewares: [
    Crawly.Middlewares.DomainFilter,
    Crawly.Middlewares.UniqueRequest,
    {Crawly.Middlewares.UserAgent, user_agents: ["Crawly Bot"]}
  ],
  pipelines: [
    {Crawly.Pipelines.Validate, fields: [:url, :title]},
    {Scraper.EctoPipeline, fields: [:url, :title]}
  ]

import_config "#{Mix.env()}.exs"
