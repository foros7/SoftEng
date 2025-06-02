package com.mycompany.softeng.dao;

import java.util.List;

public interface BaseDAO<T> {
    T create(T entity) throws Exception;

    T getById(int id) throws Exception;

    List<T> getAll() throws Exception;

    T update(T entity) throws Exception;

    boolean delete(int id) throws Exception;
}