# GUIDELINES - Agent Collaboration Use Cases

How to combine agents across divisions to achieve business outcomes. Each use case identifies the agents involved, the execution sequence, handoff points, and expected deliverables.

---

## Table of Contents

- [Design Use Cases](#design-use-cases)
- [Software Engineering Use Cases](#software-engineering-use-cases)
- [Marketing Use Cases](#marketing-use-cases)
- [Product Use Cases](#product-use-cases)
- [Project Management Use Cases](#project-management-use-cases)
- [Specialized Functions Use Cases](#specialized-functions-use-cases)
- [Strategy Use Cases](#strategy-use-cases)
- [Cross-Functional Use Cases](#cross-functional-use-cases)

---

## Design Use Cases

### 1. Complete Brand Identity from Scratch

**Goal**: Establish a comprehensive brand identity system for a new product or company.

**Agents (in sequence)**:
1. **UX Researcher** - Conducts user interviews, creates personas, maps user journeys, identifies emotional touchpoints and audience demographics
2. **Brand Guardian** - Takes research insights and develops brand strategy (purpose, vision, mission, values), visual identity (logos, color palette, typography), and voice/messaging architecture
3. **UI Designer** - Translates brand identity into a design token system (CSS variables for colors, spacing, typography, shadows) and component library with dark mode support
4. **UX Architect** - Creates the technical CSS architecture, layout frameworks, responsive breakpoints, and theme toggle implementation that developers consume
5. **Visual Storyteller** - Develops brand narrative assets (storyboards, video concepts, infographic templates, photography direction) aligned with the identity system
6. **Whimsy Injector** - Adds personality layer: micro-interactions, playful error messages, Easter eggs, and celebration moments that reinforce brand character

**Handoff Points**:
- Research insights document -> Brand Guardian
- Brand guidelines + tokens -> UI Designer
- Design system + tokens -> UX Architect
- Complete identity package -> Visual Storyteller + Whimsy Injector

**Deliverables**: Research brief, brand strategy document, visual identity system, CSS design tokens, component library, responsive framework, brand narrative assets, micro-interaction specifications.

---

### 2. AI-Powered Visual Asset Pipeline

**Goal**: Create a scalable visual content production system using AI image generation with inclusive representation.

**Agents (in sequence)**:
1. **Brand Guardian** - Defines visual brand guidelines: approved color palettes, photography styles, composition rules, and forbidden visual patterns
2. **Cultural Intelligence Strategist** - Establishes inclusive representation requirements: demographic targets, cultural accuracy standards, bias prevention rules, and dignity guidelines
3. **Inclusive Visuals Specialist** - Creates negative-prompt libraries blocking AI stereotypes, builds technical constraint frameworks for authentic representation across cultures and identities
4. **Image Prompt Engineer** - Develops structured prompt templates (portrait, product, lifestyle, landscape) incorporating brand guidelines and inclusion constraints for Midjourney, DALL-E, Stable Diffusion, and Flux
5. **Visual Storyteller** - Art-directs the generated assets into cohesive visual narratives across platforms, ensuring story consistency and emotional impact

**Handoff Points**:
- Brand visual guidelines -> Cultural Intelligence Strategist
- Inclusion requirements + negative prompts -> Image Prompt Engineer
- Prompt templates -> Visual Storyteller (for art direction)

**Deliverables**: Visual brand guidelines, inclusion framework, negative-prompt libraries, platform-specific prompt templates, art-directed visual asset library, multi-platform visual narrative.

---

### 3. UX Research to Implementation Pipeline

**Goal**: Validate design decisions with real user data before committing engineering resources.

**Agents (parallel + sequential)**:
1. **UX Researcher** - Runs usability tests, interviews, surveys, and behavioral analytics to identify pain points and validate design hypotheses
2. **Behavioral Nudge Engine** - Analyzes research data to design engagement loops, cadence personalization, and cognitive load reduction strategies
3. **UI Designer** (parallel with #2) - Creates wireframes, prototypes, and component designs informed by research findings
4. **Accessibility Auditor** - Audits designs against WCAG 2.2 AA with screen reader testing, keyboard navigation, and cognitive accessibility review
5. **UX Architect** - Converts audited designs into developer-ready CSS architecture with responsive breakpoints and accessibility foundations

**Handoff Points**:
- Research findings -> Behavioral Nudge Engine + UI Designer (parallel)
- Designs + nudge specifications -> Accessibility Auditor
- Audited designs -> UX Architect

**Deliverables**: Research report with personas and journey maps, engagement loop design, component prototypes, accessibility audit report with remediation guidance, developer-ready CSS architecture.

---

## Software Engineering Use Cases

### 4. Full-Stack Application Development

**Goal**: Build a production-ready web application from specification to deployment.

**Agents (sequence with Dev-QA loops)**:
1. **Backend Architect** - Designs system architecture: microservices boundaries, database schema (PostgreSQL), API contracts (REST/GraphQL), authentication (OAuth 2.0), and event-driven patterns (RabbitMQ)
2. **Frontend Developer** - Scaffolds React/Vue/Angular application with TypeScript, implements components from design system, optimizes Core Web Vitals, ensures WCAG accessibility
3. **DevOps Automator** - Sets up CI/CD pipelines (GitHub Actions), Docker containerization, Kubernetes orchestration, blue-green deployment, monitoring (Prometheus/Grafana)
4. **Evidence Collector** (QA loop) - Tests each feature with Playwright screenshots across devices, verifies interactive elements, catches visual regressions
5. **API Tester** (QA loop) - Validates all endpoints for functional correctness, security (OWASP), performance (k6 load testing), and contract compliance
6. **Security Engineer** - Performs threat modeling (STRIDE), secure code review (Semgrep), dependency scanning (Trivy), and zero-trust architecture validation
7. **Reality Checker** - Final integration testing, specification compliance verification, production readiness certification

**Quality Gates**: Each feature goes through Dev-QA loop (max 3 retries) before advancing. Security review required before production.

**Deliverables**: Database schema, API specification, working frontend, CI/CD pipeline, security assessment, production deployment, monitoring dashboards.

---

### 5. Security-Hardened API Development

**Goal**: Build a production API with defense-in-depth security from day one.

**Agents (layered sequence)**:
1. **Backend Architect** - Designs API architecture with security boundaries, rate limiting, input validation, and database schema with parameterized queries
2. **Security Engineer** - Performs pre-implementation threat modeling (STRIDE), defines security requirements, establishes authentication/authorization patterns, and creates security test cases
3. **Backend Architect** (implements with security patterns) - Builds the API following Security Engineer's requirements
4. **Threat Detection Engineer** - Writes Sigma detection rules for the API's attack surface, maps MITRE ATT&CK coverage, creates alerting for suspicious patterns
5. **API Tester** - Tests functional correctness, OWASP Top 10 vulnerabilities, authentication bypass attempts, authorization escalation, input injection
6. **Performance Benchmarker** - Load tests at 10x expected traffic to ensure security controls don't degrade under pressure

**Handoff Points**:
- Architecture design -> Security Engineer (threat model)
- Security requirements -> Backend Architect (implementation)
- Deployed API -> Threat Detection Engineer + API Tester + Performance Benchmarker (parallel)

**Deliverables**: Threat model, security requirements, hardened API, SIEM detection rules, security test results, performance benchmarks.

---

### 6. DevOps Pipeline Setup with Monitoring

**Goal**: Establish a complete development infrastructure from source control to production monitoring.

**Agents (sequential)**:
1. **DevOps Automator** - Creates Infrastructure as Code (Terraform), CI/CD pipelines (GitHub Actions), container orchestration (Kubernetes), secrets management, and deployment strategies (blue-green, canary)
2. **Infrastructure Maintainer** - Provisions cloud resources, configures Prometheus monitoring, sets up logging/alerting stack, implements automated backup and disaster recovery, hardens security
3. **Incident Response Commander** - Establishes incident management framework: severity classification (P0-P3), PagerDuty integration, runbooks, on-call rotation, SLO/SLI targets, and blameless post-mortem templates
4. **Workflow Optimizer** - Reviews the complete pipeline for bottlenecks, identifies automation opportunities, and optimizes developer experience

**Deliverables**: IaC configurations, CI/CD pipelines, monitoring dashboards, alerting rules, runbooks, incident response playbook, on-call rotation, optimized deployment workflow.

---

### 7. Smart Contract Development and Audit

**Goal**: Ship production-grade smart contracts with comprehensive security verification.

**Agents (sequential)**:
1. **Solidity Smart Contract Engineer** - Develops contracts following checks-effects-interactions pattern, UUPS proxy upgrades, gas optimization, and >95% Foundry test coverage
2. **Blockchain Security Auditor** - Performs static analysis (Slither, Mythril), fuzz testing (Echidna, Medusa), manual adversarial review, formal verification, economic exploit modeling, and produces audit report with PoC exploits
3. **Security Engineer** - Reviews access control patterns, dependency security, and CI/CD integration for automated security scanning
4. **Technical Writer** - Creates deployment documentation, contract interaction guides, and upgrade procedures

**Deliverables**: Audited smart contracts, comprehensive test suite, security audit report with PoC, deployment documentation.

---

### 8. Mobile App Development

**Goal**: Build and launch a cross-platform mobile application.

**Agents (parallel tracks)**:

Track A (Native):
1. **Mobile App Builder** - Develops native iOS (Swift/SwiftUI) and Android (Kotlin/Jetpack Compose) with offline-first architecture, biometric auth, and push notifications

Track B (Cross-platform):
1. **Mobile App Builder** - Builds with React Native or Flutter for rapid cross-platform delivery

Both tracks:
2. **Backend Architect** - Designs mobile-optimized API with efficient data sync, pagination, and offline conflict resolution
3. **App Store Optimizer** - Optimizes keywords, screenshots, preview videos, metadata for iOS and Android store listings
4. **Evidence Collector** - Tests on real device matrices with screenshot evidence
5. **Performance Benchmarker** - Validates battery consumption, startup time, memory usage, and network performance

**Deliverables**: Native or cross-platform app, mobile-optimized API, optimized store listings, device test matrix results, performance benchmarks.

---

## Marketing Use Cases

### 9. Multi-Channel Marketing Campaign Launch

**Goal**: Launch a coordinated marketing campaign across all digital channels simultaneously.

**Agents (phased)**:

Phase 1 - Strategy (Week 1):
1. **Trend Researcher** - Identifies current trends, competitor campaigns, audience sentiment, and optimal timing
2. **Content Creator** - Develops campaign narrative, editorial calendar, and creates core content assets (blog posts, video scripts, infographics)
3. **Brand Guardian** - Reviews all content for brand consistency, voice alignment, and visual identity compliance
4. **Growth Hacker** - Designs viral mechanics, referral loops, conversion funnels, and attribution modeling

Phase 2 - Platform Execution (Week 2):
5. **Social Media Strategist** - Coordinates cross-platform launch timing, LinkedIn campaign, and unified messaging
6. **Twitter Engager** - Executes Twitter/X campaign with threads, Spaces events, real-time engagement
7. **Instagram Curator** - Launches visual campaign with Posts, Stories, Reels, Shopping integration
8. **TikTok Strategist** - Creates short-form viral content with trending audio and creator partnerships
9. **Reddit Community Builder** - Executes authentic engagement strategy in target subreddits
10. **SEO Specialist** - Publishes optimized content, builds link authority, targets SERP features

Phase 3 - Optimize (Weeks 3-4):
11. **Analytics Reporter** - Tracks real-time KPIs, attribution, and ROI across all channels
12. **Experiment Tracker** - Runs A/B tests on top-performing content variations
13. **Executive Summary Generator** - Produces campaign performance brief for stakeholders

**Deliverables**: Campaign strategy, cross-platform content library, launch execution across 6+ channels, real-time analytics, optimization recommendations, executive performance brief.

---

### 10. Content Production Pipeline

**Goal**: Build a sustainable content engine producing high-quality content across all formats.

**Agents (continuous cycle)**:
1. **Trend Researcher** - Weekly trend reports identifying content opportunities, competitor gaps, and audience interest shifts
2. **SEO Specialist** - Keyword research, topic cluster architecture, and content optimization requirements
3. **Content Creator** - Produces content across formats: blog articles, video scripts, podcasts, infographics, social posts
4. **Brand Guardian** - Reviews all content for brand voice, messaging consistency, and visual identity
5. **Social Media Strategist** - Distributes content across platforms with unified strategy
6. **Carousel Growth Engine** - Autonomously generates daily carousel content from existing web assets for TikTok and Instagram

**Platform Distribution** (parallel):
- **Instagram Curator** - Adapts for visual-first platform
- **TikTok Strategist** - Adapts for short-form video
- **Twitter Engager** - Adapts for real-time conversation
- **Reddit Community Builder** - Adapts for community engagement

**Deliverables**: Weekly trend reports, keyword strategy, multi-format content library, cross-platform distribution, automated carousel pipeline, engagement metrics.

---

### 11. Organic Growth Strategy

**Goal**: Build sustainable organic acquisition channels reducing paid ad dependency.

**Agents (parallel workstreams)**:

Workstream A - Search:
1. **SEO Specialist** - Technical SEO audit, keyword strategy, content optimization, link building, SERP feature targeting

Workstream B - Social:
2. **Social Media Strategist** - LinkedIn thought leadership, executive branding, B2B social selling
3. **Reddit Community Builder** - Long-term community authority building
4. **Twitter Engager** - Thought leadership through threads and Spaces

Workstream C - Product:
5. **Growth Hacker** - Viral loops, referral programs, product-led growth mechanics, conversion optimization

Workstream D - Mobile:
6. **App Store Optimizer** - ASO keyword optimization, visual asset testing, localization

Measurement:
7. **Analytics Reporter** - Unified organic growth dashboard, channel attribution, CAC tracking
8. **Experiment Tracker** - A/B testing across all channels

**Deliverables**: SEO roadmap, social growth playbook, viral mechanics, ASO strategy, unified analytics dashboard, experiment results.

---

## Product Use Cases

### 12. Product Discovery and Validation

**Goal**: Validate a product idea before committing engineering resources.

**Agents (sequential)**:
1. **Trend Researcher** - TAM/SAM/SOM market sizing, competitive landscape mapping, technology trend analysis, regulatory scanning
2. **Feedback Synthesizer** - Analyzes existing customer feedback for unmet needs, pain point prioritization, and sentiment patterns
3. **UX Researcher** - Conducts user interviews and surveys, creates validated personas, maps user journeys, identifies behavioral patterns
4. **Rapid Prototyper** - Builds functional prototype in under 3 days using Next.js/Supabase for user testing
5. **Evidence Collector** - Tests prototype across devices, documents UX issues
6. **Analytics Reporter** - Analyzes prototype usage data, user behavior patterns, and conversion metrics
7. **Executive Summary Generator** - Produces GO/NO-GO recommendation with market data, user research, and prototype results

**Decision Gate**: Executive Summary Generator synthesizes all findings into SCQA-format recommendation for stakeholders.

**Deliverables**: Market analysis, competitive landscape, user research report, functional prototype, usage analytics, GO/NO-GO executive brief.

---

### 13. Sprint Planning and Feature Delivery

**Goal**: Prioritize and deliver features with maximum business value per sprint.

**Agents (cyclical)**:
1. **Feedback Synthesizer** - Synthesizes user feedback into quantified feature requests with sentiment and frequency data
2. **Sprint Prioritizer** - Applies RICE scoring, dependency mapping, and capacity planning to create optimized sprint backlog
3. **Senior Project Manager** - Converts prioritized features into developer-ready task specifications with exact acceptance criteria
4. **Behavioral Nudge Engine** - Designs engagement patterns and UX cadences for new features to maximize adoption
5. **Agents Orchestrator** - Coordinates Dev-QA loops for sprint execution with max 3 retries per task
6. **Experiment Tracker** - Sets up A/B tests for new features with proper statistical power analysis
7. **Analytics Reporter** - Tracks feature adoption, engagement metrics, and business impact post-launch

**Sprint Cadence**: This cycle repeats every 1-2 weeks, with feedback from Analytics Reporter feeding back into Feedback Synthesizer.

**Deliverables**: Prioritized backlog, task specifications, implemented features, A/B test designs, adoption metrics, sprint retrospective.

---

### 14. Data-Driven A/B Testing Program

**Goal**: Build a rigorous experimentation culture with statistically valid results.

**Agents (sequence)**:
1. **Feedback Synthesizer** - Identifies hypotheses from user feedback patterns and behavioral data
2. **Behavioral Nudge Engine** - Designs experiment variants based on behavioral psychology principles
3. **Experiment Tracker** - Creates experiment design with statistical power analysis, sample size calculation, and early stopping criteria
4. **Growth Hacker** - Implements viral and conversion experiments across acquisition funnels
5. **Analytics Reporter** - Tracks real-time experiment metrics with confidence intervals
6. **Test Results Analyzer** - Evaluates results with defect prediction, failure pattern recognition, and release readiness assessment
7. **Executive Summary Generator** - Communicates experiment outcomes to stakeholders with business impact quantification

**Deliverables**: Hypothesis backlog, experiment designs, statistical analysis, business impact reports, organizational learning documentation.

---

## Project Management Use Cases

### 15. End-to-End Project Delivery

**Goal**: Deliver a complex cross-functional project on time and within budget.

**Agents (phased)**:

Initiation:
1. **Studio Producer** - Strategic alignment: portfolio fit, ROI targets, resource allocation, executive sponsorship
2. **Project Shepherd** - Project charter: timeline with dependencies, critical path, risk register, stakeholder map

Planning:
3. **Senior Project Manager** - Specification to task breakdown with acceptance criteria and developer-ready requirements
4. **Sprint Prioritizer** - RICE-scored backlog, sprint assignments, capacity planning
5. **Jira Workflow Steward** - Sets up traceable Jira-Git workflow: branch naming, commit conventions (Gitmoji), PR templates

Execution:
6. **Agents Orchestrator** - Manages Dev-QA loops across all tasks with escalation authority
7. **Studio Operations** - Day-to-day process optimization, resource scheduling, vendor coordination

Monitoring:
8. **Finance Tracker** - Budget tracking, variance analysis, cash flow management
9. **Analytics Reporter** - Project KPI dashboards, velocity tracking, risk indicators
10. **Executive Summary Generator** - Weekly stakeholder updates in SCQA format

Closure:
11. **Workflow Optimizer** - Post-project process review, lessons learned, efficiency recommendations

**Deliverables**: Project charter, task specifications, traceable workflow, budget reports, KPI dashboards, executive updates, lessons learned.

---

### 16. Studio Operations Management

**Goal**: Run a high-performing digital studio with 95% operational efficiency.

**Agents (continuous)**:
1. **Studio Producer** - Portfolio-level strategic direction, resource allocation, and talent development
2. **Studio Operations** - SOPs, process optimization, vendor management, equipment maintenance, compliance monitoring
3. **Project Shepherd** - Individual project coordination, timeline management, stakeholder communication
4. **Jira Workflow Steward** - Code delivery workflow enforcement, traceability, and audit trails
5. **Finance Tracker** - Budget management, cost optimization, investment analysis, financial reporting
6. **Workflow Optimizer** - Continuous process improvement with Lean/Six Sigma, bottleneck identification, automation opportunities

**Operational Cadence**:
- Daily: Studio Operations (standup, resource check), Jira Workflow Steward (workflow compliance)
- Weekly: Project Shepherd (status updates), Finance Tracker (spend tracking)
- Monthly: Studio Producer (portfolio review), Workflow Optimizer (process audit)

**Deliverables**: SOPs, process maps, financial reports, workflow compliance metrics, optimization recommendations, portfolio reviews.

---

### 17. Experiment-Driven Development

**Goal**: Build a culture of systematic experimentation with measurable outcomes.

**Agents (cyclical)**:
1. **Trend Researcher** - Identifies market opportunities and emerging patterns worth testing
2. **Experiment Tracker** - Designs experiments with hypothesis, power analysis, sample size, and stopping criteria
3. **Sprint Prioritizer** - Integrates experiments into sprint planning alongside feature work
4. **Growth Hacker** - Implements growth experiments (viral loops, conversion optimization)
5. **Behavioral Nudge Engine** - Designs UX experiments targeting user engagement and retention
6. **Analytics Reporter** - Real-time experiment monitoring with statistical dashboards
7. **Test Results Analyzer** - Evaluates outcomes with ML-based defect prediction and quality debt analysis
8. **Executive Summary Generator** - Communicates results and business impact to stakeholders

**Deliverables**: Experiment registry, experiment designs, sprint integration plans, real-time dashboards, statistical analysis reports, organizational learning database.

---

## Specialized Functions Use Cases

### 18. Compliance and Audit Preparation

**Goal**: Achieve SOC 2, ISO 27001, or HIPAA certification with engineering-integrated controls.

**Agents (sequential)**:
1. **Legal Compliance Checker** - Identifies applicable regulatory frameworks (GDPR, CCPA, HIPAA, SOX, PCI-DSS) and maps requirements to implementation needs
2. **Compliance Auditor** - Conducts gap assessment against target certification, builds controls implementation roadmap, establishes evidence collection processes
3. **Security Engineer** - Implements technical security controls: encryption, access management, vulnerability scanning, zero-trust architecture
4. **Threat Detection Engineer** - Builds detection rules mapped to compliance control objectives, establishes monitoring for compliance-relevant events
5. **Infrastructure Maintainer** - Implements infrastructure controls: automated backups, disaster recovery testing, security hardening, audit logging
6. **Evidence Collector** - Systematically collects and organizes audit evidence across all control domains
7. **Executive Summary Generator** - Produces audit readiness scorecard and stakeholder communication

**Deliverables**: Regulatory mapping, gap assessment, controls implementation, detection rules, infrastructure hardening, evidence packages, audit readiness scorecard.

---

### 19. Enterprise Sales Data Operations

**Goal**: Build an automated sales intelligence pipeline from raw data to executive dashboards.

**Agents (pipeline)**:
1. **Sales Data Extraction Agent** - Monitors Excel files, extracts MTD/YTD/Year End projections with flexible schema parsing, representative matching, and transaction-based persistence
2. **Data Consolidation Agent** - Aggregates data across territories and representatives, creates performance rankings, pipeline snapshots, and trend analysis with sub-1-second load times
3. **Report Distribution Agent** - Automates daily (8AM) and weekly (Monday 7AM) report delivery with territory-aware routing, manager summaries, and HTML formatting
4. **Data Analytics Reporter** - Creates strategic dashboards with RFM segmentation, predictive modeling, and advanced visualizations (Tableau/Power BI)
5. **Finance Tracker** - Integrates sales data into financial forecasting, budget variance analysis, and commission calculations
6. **Executive Summary Generator** - Produces C-suite sales performance briefings in SCQA format

**Deliverables**: Automated data extraction pipeline, consolidated dashboards, scheduled report distribution, strategic analytics, financial integration, executive briefings.

---

### 20. Blockchain and Web3 Development

**Goal**: Build and launch secure decentralized applications.

**Agents (sequential)**:
1. **Backend Architect** - Designs system architecture bridging on-chain and off-chain components, API design, and data persistence strategy
2. **Solidity Smart Contract Engineer** - Develops production-grade EVM contracts with gas optimization, UUPS proxies, and >95% Foundry test coverage
3. **Blockchain Security Auditor** - Comprehensive security audit with static analysis, fuzz testing, formal verification, economic modeling, and PoC exploits
4. **Agentic Identity & Trust Architect** - Designs cryptographic identity and trust verification for agent-to-contract interactions
5. **Frontend Developer** - Builds Web3 frontend with wallet integration, transaction signing, and blockchain state management
6. **Security Engineer** - Reviews end-to-end security: frontend vulnerabilities, API security, key management, and supply chain risks
7. **Technical Writer** - Creates contract documentation, integration guides, and audit summaries

**Deliverables**: System architecture, audited smart contracts, identity framework, Web3 frontend, security assessment, documentation.

---

### 21. Multi-Agent Identity and Trust Framework

**Goal**: Establish secure identity and coordination infrastructure for multi-agent systems.

**Agents (layered)**:
1. **Agentic Identity & Trust Architect** - Designs cryptographic identity schema, peer verification protocol, trust scoring model, and delegation chain verification with post-quantum readiness
2. **Identity Graph Operator** - Implements shared identity resolution layer: deterministic matching, merge/split operations, evidence-based conflict resolution, PII masking, and append-only audit trails
3. **Compliance Auditor** - Validates identity infrastructure meets regulatory requirements (GDPR data minimization, CCPA rights management)
4. **Security Engineer** - Penetration testing of identity systems, credential rotation verification, and zero-trust validation

**Deliverables**: Identity schema, trust scoring model, identity resolution engine, compliance validation, security assessment, operational documentation.

---

### 22. Knowledge Management System

**Goal**: Build an organizational knowledge base that grows organically and stays useful.

**Agents (setup + continuous)**:
1. **ZK Steward** - Establishes Zettelkasten-based knowledge architecture: atomic notes, meaningful connectivity (2+ links per note), structure notes, daily logging, and domain-expert perspective switching
2. **Technical Writer** - Creates foundational documentation: architecture guides, API references, onboarding tutorials
3. **Developer Advocate** - Builds developer-facing knowledge resources: quick-start guides, code examples, FAQ responses, community documentation
4. **Workflow Optimizer** - Designs knowledge capture workflows integrated into existing development and support processes

**Continuous Cycle**:
- ZK Steward captures and connects new knowledge daily
- Technical Writer maintains documentation currency
- Developer Advocate ensures developer accessibility
- Workflow Optimizer periodically audits and improves the capture process

**Deliverables**: Zettelkasten knowledge base, technical documentation, developer resources, knowledge capture workflows.

---

### 23. ML Model Lifecycle Management

**Goal**: Develop, validate, deploy, and monitor ML models with rigorous quality standards.

**Agents (lifecycle)**:
1. **AI Engineer** - Develops models using TensorFlow/PyTorch, builds data pipelines, implements MLOps with MLflow, addresses bias and fairness
2. **Data Engineer** - Builds data infrastructure: ETL/ELT pipelines (Spark, dbt), Medallion Architecture, data quality checks (Great Expectations), streaming integration (Kafka)
3. **Model QA Specialist** - Independent audit: replicates results, tests calibration, analyzes SHAP feature behavior, validates fairness metrics, stress tests with Population Stability Index
4. **Data Analytics Reporter** - Creates model performance dashboards, tracks drift metrics, monitors business KPIs impacted by model predictions
5. **Compliance Auditor** - Validates model governance against regulatory requirements (GDPR automated decision-making, fairness documentation)

**Deliverables**: Trained model, data pipeline, QA audit report with SHAP analysis, performance dashboards, compliance documentation.

---

## Strategy Use Cases

### 24. Full NEXUS Pipeline Execution

**Goal**: Take a product from concept to production using the complete 7-phase pipeline.

**Pipeline (see strategy documents for full details)**:
1. **Phase 0 - Discovery** (3-7 days): Trend Researcher + Feedback Synthesizer + UX Researcher + Analytics Reporter + Legal Compliance Checker + Tool Evaluator -> GO/NO-GO decision
2. **Phase 1 - Strategy** (5-10 days): Studio Producer + Brand Guardian + Finance Tracker + UX Architect + Backend Architect + AI Engineer + Senior PM + Sprint Prioritizer -> Architecture Package
3. **Phase 2 - Foundation** (3-5 days): DevOps Automator + Infrastructure Maintainer + Studio Operations + Frontend Developer + Backend Architect + UX Architect -> Technical skeleton
4. **Phase 3 - Build** (2-12 weeks): Agents Orchestrator manages Dev-QA loops across 4 parallel tracks with all developer, QA, and specialist agents
5. **Phase 4 - Hardening** (3-7 days): Evidence Collector + API Tester + Performance Benchmarker + Legal Compliance Checker + Reality Checker -> Production certification
6. **Phase 5 - Launch** (2-4 weeks): All marketing agents + DevOps + Infrastructure + Support + Analytics -> Go-to-market execution
7. **Phase 6 - Operate** (ongoing): Continuous monitoring, improvement loops, and operational cadences

**Deployment Modes**:
- **Full**: All 7 phases, 40+ agents, complete products (8-20 weeks)
- **Sprint**: Phases 1-5 compressed, 18-30 agents, major features (4-12 weeks)
- **Micro**: Targeted subset, 3-10 agents, specific tasks (1-5 days)

---

### 25. Startup MVP in 4-6 Weeks

**Goal**: Launch a minimum viable product with validated market fit.

**Agents (compressed NEXUS-Sprint)**:

Week 1 - Discovery + Architecture:
1. **Trend Researcher** + **UX Researcher** - Rapid market and user validation
2. **Backend Architect** + **UX Architect** - System architecture and design foundations
3. **Sprint Prioritizer** - MVP scope definition with RICE scoring

Weeks 2-3 - Core Build:
4. **Frontend Developer** + **Backend Architect** + **Rapid Prototyper** - Feature implementation through Dev-QA loops
5. **Evidence Collector** - Continuous QA with screenshot evidence
6. **Agents Orchestrator** - Loop management and escalation

Week 4 - Polish + Hardening:
7. **Reality Checker** - Integration testing and production readiness
8. **Performance Benchmarker** - Load testing at scale

Weeks 5-6 - Launch:
9. **Growth Hacker** - Launch strategy and viral mechanics
10. **Content Creator** - Launch content pipeline
11. **Analytics Reporter** - Real-time metrics tracking

**Key Pitfalls to Avoid**: Scope creep (Sprint Prioritizer enforces), skipping QA (Agents Orchestrator enforces max 3 retries), premature optimization (Rapid Prototyper focuses on validation over perfection).

**Deliverables**: Validated MVP, production deployment, launch campaign, growth analytics, post-launch optimization plan.

---

### 26. Enterprise Feature Development (6-12 Weeks)

**Goal**: Add a major feature to an existing enterprise product with compliance and stakeholder alignment.

**Agents (NEXUS-Sprint with compliance emphasis)**:

Weeks 1-2 - Requirements + Architecture:
1. **Project Shepherd** - Stakeholder alignment, requirements gathering, risk register
2. **Legal Compliance Checker** - Regulatory impact assessment
3. **Backend Architect** + **Frontend Developer** - Technical design
4. **Sprint Prioritizer** - Feature decomposition and dependency mapping

Week 3 - Foundation:
5. **DevOps Automator** - Feature flag infrastructure, staging environment
6. **Security Engineer** - Pre-implementation threat model

Weeks 4-9 - Build:
7. **Agents Orchestrator** - Dev-QA loops with compliance checkpoints
8. **Evidence Collector** + **API Tester** - Continuous quality verification

Weeks 10-11 - Hardening:
9. **Reality Checker** - Comprehensive integration testing
10. **Performance Benchmarker** - Load testing at 10x expected traffic
11. **Compliance Auditor** - Evidence collection for audit trail

Week 12 - Canary Rollout:
12. **DevOps Automator** - Canary deployment with automatic rollback
13. **Infrastructure Maintainer** - Production monitoring
14. **Executive Summary Generator** - Stakeholder communication at each milestone

**Deliverables**: Requirements document, compliance assessment, feature implementation, security review, performance benchmarks, compliance evidence, canary rollout, stakeholder updates.

---

### 27. Production Incident Response

**Goal**: Detect, resolve, and learn from production incidents with minimal customer impact.

**Agents (severity-based team composition)**:

P0 (Critical - full outage):
1. **Infrastructure Maintainer** - Real-time diagnostics, system health assessment
2. **DevOps Automator** - Rollback execution, traffic rerouting, scaling
3. **Backend Architect** - Root cause investigation, code-level diagnosis
4. **Frontend Developer** - UI-level diagnosis if applicable
5. **Support Responder** - Customer communication, status page updates
6. **Executive Summary Generator** - Real-time executive briefing
7. **Incident Response Commander** - Coordinates all activities, runs timeline, assigns actions

P1 (High - degraded service):
1. **Infrastructure Maintainer** + **DevOps Automator** + relevant developer agent
2. **Support Responder** - Customer communication
3. **Incident Response Commander** - Coordination

P2 (Medium - minor impact):
1. Relevant developer agent + **Evidence Collector**

P3 (Low - cosmetic):
1. **Sprint Prioritizer** - Add to backlog for next sprint

Post-Incident (all severities):
1. **Incident Response Commander** - Blameless post-mortem with 5 Whys analysis
2. **Threat Detection Engineer** - Creates new detection rules for the failure mode
3. **Workflow Optimizer** - Process improvements to prevent recurrence
4. **Executive Summary Generator** - Post-mortem summary for stakeholders

**Deliverables**: Incident timeline, resolution actions, status page updates, executive briefings, post-mortem report, new detection rules, process improvements.

---

## Cross-Functional Use Cases

### 28. Product Launch (End-to-End)

**Goal**: Coordinate all divisions for a complete product launch from brand to market.

This is the highest-level cross-functional use case, combining agents from every division.

**Phase 1 - Foundation** (Weeks 1-2):
- Design: UX Researcher -> Brand Guardian -> UI Designer -> UX Architect
- Product: Trend Researcher + Feedback Synthesizer
- PM: Studio Producer + Project Shepherd + Senior PM

**Phase 2 - Build** (Weeks 3-8):
- Engineering: Backend Architect + Frontend Developer + DevOps Automator
- Testing: Evidence Collector + API Tester + Accessibility Auditor
- Design: Visual Storyteller + Whimsy Injector + Image Prompt Engineer
- Product: Sprint Prioritizer + Behavioral Nudge Engine
- PM: Jira Workflow Steward + Agents Orchestrator

**Phase 3 - Harden** (Weeks 9-10):
- Testing: Reality Checker + Performance Benchmarker + Test Results Analyzer
- Security: Security Engineer + Compliance Auditor
- Support: Legal Compliance Checker

**Phase 4 - Launch** (Weeks 11-14):
- Marketing: ALL marketing agents activated simultaneously
- Engineering: DevOps Automator (blue-green deploy) + Infrastructure Maintainer (monitoring)
- Support: Support Responder + Analytics Reporter
- PM: Finance Tracker + Executive Summary Generator

**Phase 5 - Operate** (Ongoing):
- Support: Infrastructure Maintainer + Support Responder + Analytics Reporter
- Product: Feedback Synthesizer + Experiment Tracker
- Marketing: Content Creator + Social Media Strategist (continuous)
- PM: Studio Producer (quarterly reviews) + Workflow Optimizer (process improvement)

**Deliverables**: Complete product with brand identity, production infrastructure, multi-channel launch campaign, customer support, analytics, and ongoing operations.

---

### 29. Digital Transformation Initiative

**Goal**: Modernize legacy business processes with automated, AI-powered workflows.

**Phase 1 - Assessment**:
1. **Workflow Optimizer** - Maps current business processes, identifies bottlenecks and automation opportunities
2. **Tool Evaluator** - Evaluates technology options with TCO, ROI, and integration analysis
3. **Compliance Auditor** - Assesses regulatory requirements for automated processes
4. **Finance Tracker** - Budget analysis, investment modeling, payback period calculation

**Phase 2 - Architecture**:
5. **Backend Architect** - Designs integration architecture, data flows, API contracts
6. **Data Engineer** - Builds data pipelines connecting legacy and modern systems
7. **AI Engineer** - Designs ML models for process automation and decision support
8. **Security Engineer** - Threat modeling for new attack surfaces

**Phase 3 - Implementation**:
9. **Agents Orchestrator** - Coordinates Dev-QA loops across all integration points
10. **DevOps Automator** - CI/CD for new services, canary rollouts
11. **Identity Graph Operator** - Resolves entity identities across legacy and modern systems

**Phase 4 - Rollout**:
12. **Support Responder** - Change management support, user training
13. **Analytics Reporter** - Adoption tracking, efficiency metrics
14. **Executive Summary Generator** - Transformation progress reporting

**Deliverables**: Process assessment, technology recommendations, integration architecture, data pipelines, ML models, deployed services, adoption metrics, executive reports.

---

### 30. Quarterly Business Review Package

**Goal**: Produce a comprehensive quarterly performance package for executive stakeholders.

**Agents (parallel data gathering + sequential synthesis)**:

Data Gathering (parallel):
1. **Analytics Reporter** - Product KPIs, user metrics, engagement trends, cohort analysis
2. **Finance Tracker** - Revenue, costs, margins, budget variance, cash flow, unit economics
3. **Data Analytics Reporter** - Customer analytics, segmentation, lifetime value, churn prediction
4. **Feedback Synthesizer** - NPS analysis, satisfaction trends, feature request rankings
5. **Trend Researcher** - Market shifts, competitive movements, technology trends, regulatory changes

Synthesis:
6. **Data Consolidation Agent** - Aggregates metrics across all sources into unified dashboard
7. **Executive Summary Generator** - Produces C-suite SCQA brief with situation analysis, key findings, strategic implications, and prioritized recommendations

**Deliverables**: Product analytics dashboard, financial summary, customer intelligence report, market update, unified executive brief with quantified recommendations.

---

## Quick Reference: Agent Pairing Patterns

| Business Need | Primary Agent | Supporting Agents |
|---|---|---|
| New feature | Sprint Prioritizer | Senior PM, Agents Orchestrator, Evidence Collector |
| Brand identity | Brand Guardian | UX Researcher, UI Designer, Visual Storyteller |
| API development | Backend Architect | Security Engineer, API Tester, Technical Writer |
| Marketing launch | Social Media Strategist | Content Creator, platform specialists, Growth Hacker |
| Compliance | Legal Compliance Checker | Compliance Auditor, Security Engineer, Evidence Collector |
| Performance issue | Performance Benchmarker | Infrastructure Maintainer, Backend Architect, DevOps Automator |
| User research | UX Researcher | Feedback Synthesizer, Behavioral Nudge Engine, Analytics Reporter |
| Incident | Incident Response Commander | Infrastructure Maintainer, DevOps Automator, Support Responder |
| Data pipeline | Data Engineer | AI Engineer, Data Analytics Reporter, Model QA Specialist |
| Security audit | Security Engineer | Threat Detection Engineer, Blockchain Security Auditor, Compliance Auditor |
| Content creation | Content Creator | SEO Specialist, Brand Guardian, platform specialists |
| Project delivery | Project Shepherd | Sprint Prioritizer, Jira Workflow Steward, Finance Tracker |
| Executive communication | Executive Summary Generator | Analytics Reporter, Finance Tracker, Trend Researcher |
| Mobile app | Mobile App Builder | App Store Optimizer, Backend Architect, Evidence Collector |
| Smart contracts | Solidity Engineer | Blockchain Security Auditor, Security Engineer, Technical Writer |

---

## Principles for Agent Collaboration

1. **Evidence Over Claims**: Every agent handoff must include concrete artifacts (screenshots, test results, metrics), not assertions.

2. **Dev-QA Loop**: The core quality mechanism. Every implementation passes through build-test-verify with max 3 retries before escalation.

3. **Quality Gates**: No phase advances without meeting exit criteria. Reality Checker defaults to "NEEDS WORK" and requires overwhelming evidence for approval.

4. **Parallel Execution**: Independent workstreams run simultaneously. Design and engineering can work in parallel once the architecture is defined. Platform-specific marketing agents always execute in parallel.

5. **Context Preservation**: Use standardized handoff templates to prevent context loss between agents. The workflow-with-memory template demonstrates MCP-based persistent state for automated handoffs.

6. **Fail Fast**: Maximum 3 retries on any task before escalating. Stalled agents should request help rather than repeat failed approaches.

7. **Minimal Viable Team**: Not every use case needs all agents. Start with the smallest effective team and add specialists as needed. Use NEXUS-Micro for targeted tasks, Sprint for features, Full only for complete products.
