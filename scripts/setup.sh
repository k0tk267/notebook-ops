#!/bin/bash
sed -i "s/your_project_name/$1/g" pyproject.toml
sed -i "s/your_name/$2/g" pyproject.toml
sed -i "s/your_email/$3/g" pyproject.toml
sed -i "s/your_package_name/$4/g" pyproject.toml

cp .env.example .env
sed -i -e "s|<replace your project PATH>|$PWD|" .env
