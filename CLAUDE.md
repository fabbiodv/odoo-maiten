# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the Odoo ERP system, a comprehensive suite of web-based open source business applications. It follows a modular architecture where each business function (accounting, CRM, inventory, etc.) is implemented as an addon/module.

## Development Commands

### Running Odoo
```bash
# Start the Odoo server
python3 odoo-bin

# Run with specific configuration
python3 odoo-bin -c /path/to/config.conf

# Install/upgrade modules
python3 odoo-bin -d database_name -i module_name
python3 odoo-bin -d database_name -u module_name

# Run in development mode with auto-reload
python3 odoo-bin --dev=all

# Run shell
python3 odoo-bin shell -d database_name
```

### Testing
```bash
# Run tests for a specific module
python3 odoo-bin -d test_database --test-tags module_name

# Run specific test class
python3 odoo-bin -d test_database --test-tags /path/to/test_file

# Run all tests
python3 odoo-bin -d test_database --test-tags=standard

# Run tests without creating demo data
python3 odoo-bin -d test_database --test-tags module_name --without-demo=all
```

### Database Operations
```bash
# Create database
python3 odoo-bin -d database_name --init=base

# Update modules list
python3 odoo-bin -d database_name --update=all

# Neutralize database (remove sensitive data)
python3 odoo-bin neutralize -d database_name
```

## Architecture and Structure

### Core Architecture
- **`odoo/`**: Core framework containing ORM, HTTP server, CLI tools, and base functionality
- **`addons/`**: Standard business modules (accounting, CRM, inventory, etc.)
- **`odoo-bin`**: Main entry point script that starts the Odoo server or runs CLI commands

### Module Structure
Each Odoo module follows a standard structure:
- **`__manifest__.py`**: Module metadata and dependencies
- **`models/`**: Python files defining database models and business logic
- **`views/`**: XML files defining user interface layouts
- **`static/`**: JavaScript, CSS, and other web assets
- **`security/`**: Access rights and record rules
- **`data/`**: Initial data and configuration
- **`tests/`**: Python test files
- **`wizard/`**: Transient models for user interactions

### Key Framework Components
- **ORM**: Located in `odoo/models.py`, provides ActiveRecord-style database abstraction
- **HTTP Framework**: `odoo/http.py` handles web requests and routing
- **CLI Tools**: `odoo/cli/` contains commands for database management, module installation, etc.
- **QWeb**: Template engine for reports and web pages
- **Workflow Engine**: Built-in state machine for business processes

### Database Models
- Models inherit from `models.Model`, `models.TransientModel`, or `models.AbstractModel`
- Field types include `fields.Char`, `fields.Integer`, `fields.Many2one`, `fields.One2many`, etc.
- Use decorators like `@api.depends`, `@api.onchange`, `@api.constrains`

### Localization Structure
- Country-specific modules follow pattern `l10n_<country_code>`
- Localization includes chart of accounts, taxes, and legal requirements
- Translation files are stored in `i18n/` directories

### Testing Framework
- Tests inherit from `odoo.tests.TransactionCase` or `odoo.tests.HttpCase`
- Test files are located in `tests/` directories within modules
- Use `tagged` decorator to organize tests by functionality
- Test data can be loaded from `demo/` directories

### Configuration
- Main configuration handled by `odoo/tools/config.py`
- Configuration files use standard INI format
- Environment variables can override configuration values

### Development Best Practices
- Follow the module structure conventions strictly
- Always define proper access rights in `security/ir.model.access.csv`
- Use appropriate field types and constraints
- Write comprehensive tests for business logic
- Ensure proper translation support with `_()` function calls